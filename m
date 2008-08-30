Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYH3AYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYH3AYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYH3AYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:24:23 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:32274 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751472AbYH3AYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:24:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.ar;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=6ilUNCf/kvN9ElC555/Onh6im7XTdT+cAnzGncVYP7x1SwvXwbF1vwgYPQY2/Ph9QNm31G1Unz5Mhf5kmP42fjde0Z6KjOR6XJPfAN764GE4P8LeTjtUAf/XQn+679zvDUpZz1ii32mm7zf7MkJpzZZeJu1zFSgsAFa2pEXrzuY=  ;
X-YMail-OSG: qGQd7q0VM1mr4veTKjeVz31HJ8gExqQPTSLtjEncpaAsVE0Cnlt8BwgfYIdGBp3ZLfliyysRe17h3UArfdvt3wbygYHwnRlspN3hDnwBDqoPUw3yaA621UBHSz6SIdBk4ZLIeMHQt0kFYPkMJF799hBi
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48B89325.90801@yahoo.com.ar>
Date: Fri, 29 Aug 2008 21:24:05 -0300
From: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [ 2.6.27-rc5 ] x86-32 results of CONFIG_DEBUG_SECTION_MISMATCH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using:
http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.27-rc5.tar.bz2

The config is here: http://pastebin.com/f1754954e


WARNING: vmlinux.o(.text+0x85a4): Section mismatch in reference from the
function setup_trampoline() to the variable .cpuinit.data:trampoline_end
The function setup_trampoline() references
the variable __cpuinitdata trampoline_end.
This is often because setup_trampoline lacks a __cpuinitdata
annotation or the annotation of trampoline_end is wrong.

WARNING: vmlinux.o(.text+0x85ac): Section mismatch in reference from the
function setup_trampoline() to the variable .cpuinit.data:trampoline_data
The function setup_trampoline() references
the variable __cpuinitdata trampoline_data.
This is often because setup_trampoline lacks a __cpuinitdata
annotation or the annotation of trampoline_data is wrong.

WARNING: vmlinux.o(.data+0x57f4): Section mismatch in reference from the
variable contig_page_data to the variable .init.data:bootmem_node_data
The variable contig_page_data references
the variable __initdata bootmem_node_data
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference
from the variable initial_code to the function
.init.text:i386_start_kernel()
The variable __cpuinitdata initial_code references
a function __init i386_start_kernel().
If i386_start_kernel is only used by initial_code then
annotate i386_start_kernel with a matching annotation.

WARNING: vmlinux.o(.cpuinit.data+0xfd0): Section mismatch in reference
from the variable trampoline_data to the variable .init.text:startup_32_smp
The variable __cpuinitdata trampoline_data references
a variable __init startup_32_smp.
If startup_32_smp is only used by trampoline_data then
annotate startup_32_smp with a matching annotation.

Chau,

-- 
Gerardo Exequiel Pozzi ( djgera )
http://www.djgera.com.ar
KeyID: 0x1B8C330D
Key fingerprint = 0CAA D5D4 CD85 4434 A219  76ED 39AB 221B 1B8C 330D


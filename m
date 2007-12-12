Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbXLLIR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbXLLIR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbXLLIRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:17:19 -0500
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:33331 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbXLLIRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:17:18 -0500
Date: Wed, 12 Dec 2007 09:17:15 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212091715.7f89fd22@fastwebnet.it>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 00:31:18 +0100
Rene Herman <rene.herman@gmail.com> wrote:
> 
> and on a PII 400 (Intel 440BX chipset) a constant:
> 
> rene@6bap:~/src/port80$ su -c ./port80
> cycles: out 553, in 251
> 
> Results are (mostly) independent of compiler optimisation, but testing with 
> an -O2 compile should be most useful. Thanks!
>

### Core2 Duo 1.8 GHz ###

X86_64 -m32 -O2:

$ for i in `seq 5`; do sudo ./port80; sleep 1; done
cycles: out 1498, in 964
cycles: out 1498, in 964
cycles: out 1499, in 964
cycles: out 1498, in 964
cycles: out 1498, in 965

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping	: 6
cpu MHz		: 1864.805
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3731.82
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

[...]


-- 
	Paolo Ornati
	Linux 2.6.24-rc4-g94545bad on x86_64

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbZDQOqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbZDQOqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761115AbZDQOq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:46:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36133 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699AbZDQOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:46:28 -0400
Date: Fri, 17 Apr 2009 16:46:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SSE soft emulation for Linux?
Message-ID: <alpine.LSU.2.00.0904171632550.3060@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


well as it happens, a user reported to me that some binary userspace 
blobs shipped with popular game servers crashes with Illegal 
Instruction. Upon review, the program tries to execute SSE code, which, 
of course, is bound to fail on older CPUs (see below for /proc/cpuinfo).

So I was wondering if there is an SSE emulation kit (for x86_32) similar 
to the FPU emu code for arch/x86/, to deal with such cases.

> cat /proc/cpuinfo 
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 4
model name      : AMD Athlon(tm) Processor
stepping        : 4
cpu MHz         : 1200.039
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca 
cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow up

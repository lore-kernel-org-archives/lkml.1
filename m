Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbYECUIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbYECUIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYECUHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:07:55 -0400
Received: from aun.it.uu.se ([130.238.12.36]:55283 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbYECUHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:07:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18460.50662.535054.982353@harpo.it.uu.se>
Date: Sat, 3 May 2008 22:07:02 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hadi@cyberus.ca, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <481CB384.2070704@zytor.com>
References: <1209810775.6972.37.camel@localhost>
	<alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
	<1209834123.6972.48.camel@localhost>
	<481CB384.2070704@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > jamal wrote:
 > > 
 > > Indeed it does - thanks.
 > > 
 > >> Please provide
 > >> also output of /proc/cpuinfo.
 > > 
 > > mambo:~# cat /proc/cpuinfo
 > > processor       : 0
 > > vendor_id       : GenuineIntel
 > > cpu family      : 6
 > > model           : 3
 > > model name      : Pentium II (Klamath)
 > > stepping        : 3
 > > cpu MHz         : 1063.771
 > > cache size      : 128 KB
 > > fdiv_bug        : no
 > > hlt_bug         : no
 > > f00f_bug        : no
 > > coma_bug        : no
 > > fpu             : yes
 > > fpu_exception   : yes
 > > cpuid level     : 2
 > > wp              : yes
 > > flags           : fpu de pse tsc msr pae mce cx8 sep pge cmov mmx fxsr
 > > sse sse2
 > > bogomips        : 2160.92
 > > clflush size    : 32
 > > power management:
 > > 
 > 
 > This is very odd.
 > 
 > Could you try running the attached C program on this processor and 
 > report the result?  (Binary included for convenience.)
 > 
 > Arjan: this seems to directly contradict the Intel documentation.  Do 
 > you have any way to find out what the deal is with this?

hpa's p6nops test program works fine here on both a PII (family 6 model 3)
and a Pentium Pro (family 6 model 1 stepping 9).

I'm noticing another anomaly in jamal's /proc/cpuinfo above: since when
can a PII have sse and sse2? As far as I recall, it was the PIII that
added sse, and sse2 came with the P4.

/Mikael

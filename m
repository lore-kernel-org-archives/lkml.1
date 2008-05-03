Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYECUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYECUEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYECUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:04:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbYECUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:04:08 -0400
Message-ID: <481CC51C.3040607@zytor.com>
Date: Sat, 03 May 2008 13:03:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: hadi@cyberus.ca
CC: Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost>	 <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <1209834123.6972.48.camel@localhost>
In-Reply-To: <1209834123.6972.48.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jamal wrote:
> 
> mambo:~# cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 3
> model name      : Pentium II (Klamath)
> stepping        : 3
> cpu MHz         : 1063.771
> cache size      : 128 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu de pse tsc msr pae mce cx8 sep pge cmov mmx fxsr
> sse sse2
> bogomips        : 2160.92
> clflush size    : 32
> power management:
> 

Jamal, is this the /proc/cpuinfo from Qemu or from your hardware platform?

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYAJNPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYAJNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYAJNP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:15:29 -0500
Received: from mail001.aei.ca ([206.123.6.130]:51580 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbYAJNP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:15:28 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 08:15:28 EST
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Date: Thu, 10 Jan 2008 08:08:42 -0500
User-Agent: KMail/1.9.7
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com> <20080110124810.GA20579@elte.hu>
In-Reply-To: <20080110124810.GA20579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801100808.42945.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 10, 2008, Ingo Molnar wrote:
> 
> * Matthew <jackdachef@gmail.com> wrote:
> 
> > this also happens with rc7-based kernels, btw
> 
> hm, exactly what rc7 based kernel? Vanilla 2.6.24-rc7, built by you? Or 
> any patches ontop of it? (x86.git perhaps?)

Matthew  is not alone with this problem.  I have it too.  Its not new here.  Its
been happening as long as I have had gentoo amd64 installed.  It can be hard
to reproduce but eventually, when 32 bit apps are used, my box bricks.  There is
nothing in the logs (nor on a serial console) - the box just freezes.  

My kernel is _not_ tainted.  The kernel is currently 2.6.23-gentoo-r5-crc with 
the latest cfs backport applied; it does not seem to be critical though as it has
happen with all kernels I have tried (mm, linux and gentoo varients).  

The processor is:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 4
model name      : AMD Athlon(tm) 64 Processor 2800+
stepping        : 10
cpu MHz         : 1808.802
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow rep_good
bogomips        : 3620.77
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

I asked about this lkml before and was told it was probably a cpu/hardware issue...  Its 
interesting that Matthew is also running gentoo.

Thanks,
Ed Tomlinson

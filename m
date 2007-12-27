Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbXL0SJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbXL0SJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXL0SJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:09:33 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32172 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXL0SJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:09:32 -0500
Date: Thu, 27 Dec 2007 12:09:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
In-reply-to: <fa./Gg6lFn4vN7sfhp2nE3LSMDm0q4@ifi.uio.no>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Message-id: <4773EA58.2040605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa./Gg6lFn4vN7sfhp2nE3LSMDm0q4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Greetings,
> 
> s2ram recently became useful here, except for the kernel's annoying
> habit of disabling my P4's perfectly good TSC.
> 
> [  107.894470] CPU 1 is now offline
> [  107.894474] SMP alternatives: switching to UP code
> [  107.895832] CPU0 attaching sched-domain:
> [  107.895836]  domain 0: span 1
> [  107.895838]   groups: 1
> [  107.896097] CPU1 is down
> [    3.726156] Intel machine check architecture supported.
> [    3.726165] Intel machine check reporting enabled on CPU#0.
> [    3.726167] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
> [    3.726170] CPU0: Thermal monitoring enabled
> [    3.726175] Back to C!
> [    3.726708] Force enabled HPET at resume
> [    3.726775] Enabling non-boot CPUs ...
> [    3.727049] CPU0 attaching NULL sched-domain.
> [    3.727165] SMP alternatives: switching to SMP code
> [    3.727858] Booting processor 1/1 eip 3000
> [    3.727862] CPU 1 irqstacks, hard=b042f000 soft=b042d000
> [    3.738173] Initializing CPU#1
> [    3.798912] Calibrating delay using timer specific routine.. 5986.12 BogoMIPS (lpj=2993061)
> [    3.798920] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
> [    3.798931] CPU: Trace cache: 12K uops, L1 D cache: 8K
> [    3.798934] CPU: L2 cache: 512K
> [    3.798936] CPU: Physical Processor ID: 0
> [    3.798938] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
> [    3.798946] Intel machine check architecture supported.
> [    3.798952] Intel machine check reporting enabled on CPU#1.
> [    3.798955] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
> [    3.798959] CPU1: Thermal monitoring enabled
> [    3.799161] CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
> [    3.799187] checking TSC synchronization [CPU#0 -> CPU#1]:
> [    3.819181] Measured 63588552840 cycles TSC warp between CPUs, turning off TSC clock.
> [    3.819184] Marking TSC unstable due to: check_tsc_sync_source failed.
> 
> I wonder why I'm the only guy in the galaxy experiencing this.  Does
> everybody else's clock continue to move forward across resume or
> something?  Anyway, I asked it to please stop doing that, and it
> complied without even exploding (unlike crabby APICs).

Are we missing some logic to resync the TSCs after resume, or something?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


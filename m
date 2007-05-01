Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXEAOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXEAOsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXEAOsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:48:46 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:46747 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbXEAOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:48:45 -0400
Message-ID: <46375340.2010106@interia.pl>
Date: Tue, 01 May 2007 16:48:32 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: 2.6.21: longhaul freq-scaling broken
References: <46374BB6.9080703@web.de>
In-Reply-To: <46374BB6.9080703@web.de>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: e3eb8acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
Hi 
> the new longhaul driver of 2.6.21 is broken on my Via Eden board.
> Frequencies can no longer be switched by whatever governor.
> 
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : CentaurHauls
> cpu family      : 6
> model           : 7
> model name      : VIA Samuel 2
> stepping        : 3
> cpu MHz         : 598.000
> cache size      : 64 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu de tsc msr cx8 mtrr pge mmx 3dnow
> bogomips        : 1200.75
> clflush size    : 32
> 
> I ported the longhaul driver from 2.6.20.7 to 2.6.21, it works fine.
Yes. My fault. Bug is known, but it was to late to include patch 
fixing it in 2.6.21
> Yeah, I know there are only a few patches between both, but I would like
> to reduce the test cycles to a minimum. Any suggestion where to look
> first is welcome therefore, ready-to-apply patches even more...
Longhaul ver. 2 support is the reason. First machine that was reported 
not working is exactly like Your's: Samuel 2 600MHz. Patch reverting 
changes is queued in cpufreq git. You can find it at
http://git.kernel.org/?p=linux/kernel/git/davej/cpufreq.git;a=commitdiff_plain;h=07844252ffd81ec192a62014bada1016c9703765
> Thanks,
> Jan
Regards
Rafał



----------------------------------------------------------------------
Po meczu.....kurde...:)
>>> http://link.interia.pl/f1a72


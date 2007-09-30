Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbXI3XtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbXI3XtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXI3Xs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:48:58 -0400
Received: from mail.tmr.com ([64.65.253.246]:35385 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXI3Xs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:48:58 -0400
Message-ID: <47003742.5090604@tmr.com>
Date: Sun, 30 Sep 2007 19:54:42 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Matthew <jackdachef@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@chiara.csoma.elte.hu
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8,
 v2.6.21.7, v2.6.20.20
References: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
In-Reply-To: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew wrote:
> Hi Ingo & everbody on the list,
> 
> first of all: many thanks for developing this great scheduler (also:
> kudos to Con Kolivas for having developed SD & CK-patchset)
> 
> (this is my second mail to this list and I hope I'm doing everything right)
> 
> I'm doing some backup during work right now: rsyncing my home
> partition (nearly 180 GB) to another harddrive locally &
> since I'm running compiz-fusion, openoffice and gnome, therefore am in
> some real "working environment" I thought:
> give Ingo's new scheduler a test-ride during heavy load ;)
> 
> first some impressions:
> cpu load balancing looks great again (pretty symmetrical loading on
> both cores - it looks pretty similar to 19.1 if not better if I recall
> right),
> v20 wasn't that "good-looking" ;) (with gnome-system-monitor)
> 
> both cpus have a continous load of ~  70% right now so I'll be
> starting up 9 instances of glxgears, below are some output & details
> of my system
> (cpu frequency switching is disabled since it doesn't work right now
> with the current bios version)
> 
> short summary: unfortunately after starting glxgears everything
> stuttered a lot, don't know if it's expactable during that heavy load
> - just wanted to let you know; after having closed each instance of
> glxgears, everything was fine again ...
> 
> cat /proc/sched_debug
> Sched Debug Version: v0.05-v22, 2.6.23-rc8-cfs-v22 #1
> now at 3890590.670323 msecs
>   .sysctl_sched_latency                    : 20.000000
>   .sysctl_sched_nr_latency                 : 0.000020
>   .sysctl_sched_wakeup_granularity         : 2.000000
>   .sysctl_sched_batch_wakeup_granularity   : 25.000000
>   .sysctl_sched_child_runs_first           : 0.000001
>   .sysctl_sched_features                   : 3
> 
Try setting features to 14. That helps my similar issues.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbXEWEMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbXEWEMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 00:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEWEL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 00:11:56 -0400
Received: from holomorphy.com ([66.93.40.71]:57743 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbXEWEL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 00:11:56 -0400
Date: Tue, 22 May 2007 21:06:50 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Miguel Figueiredo <elmig@debianpt.org>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Message-ID: <20070523040650.GS19966@holomorphy.com>
References: <464F57DD.2000309@tmr.com> <46534C31.1060306@debianpt.org> <46538AB8.8030009@tmr.com> <200705241036.45179.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705241036.45179.kernel@kolivas.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 10:28, Bill Davidsen wrote:
>>> kernel    2.6.21-cfs-v13    2.6.21-ck2
>>> a)    194464        254669
>>> b)    54159        124
>> Everyone seems to like ck2, this makes it look as if the video display
>> would be really pretty unusable. While sd-0.48 does show an occasional
>> video glitch when watching video under heavy load, it's annoying rather
>> than unusable.

On Thu, May 24, 2007 at 10:36:44AM +1000, Con Kolivas wrote:
> That's because the whole premise of your benchmark relies on a workload that 
> yield()s itself to the eyeballs on most graphic card combinations when using 
> glxgears. Your test remains a test of sched_yield in the presence of your 
> workloads rather than anything else. If people like ck2 it's because in the 
> real world with real workloads it is better, rather than on a yield() based 
> benchmark. Repeatedly the reports are that 3d apps and games in normal usage 
> under -ck are better than mainline and cfs.

Maybe people should explicitly hack on sched_yield() for these things
and do comparative benchmarking of sched_yield() implementations.


-- wli

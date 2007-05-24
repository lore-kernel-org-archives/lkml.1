Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbXEWAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbXEWAiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXEWAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:38:11 -0400
Received: from mail34.syd.optusnet.com.au ([211.29.133.218]:35984 "EHLO
	mail34.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757147AbXEWAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:38:10 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Date: Thu, 24 May 2007 10:36:44 +1000
User-Agent: KMail/1.9.5
Cc: Miguel Figueiredo <elmig@debianpt.org>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <464F57DD.2000309@tmr.com> <46534C31.1060306@debianpt.org> <46538AB8.8030009@tmr.com>
In-Reply-To: <46538AB8.8030009@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241036.45179.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 10:28, Bill Davidsen wrote:
> > kernel    2.6.21-cfs-v13    2.6.21-ck2
> > a)    194464        254669
> > b)    54159        124
>
> Everyone seems to like ck2, this makes it look as if the video display
> would be really pretty unusable. While sd-0.48 does show an occasional
> video glitch when watching video under heavy load, it's annoying rather
> than unusable.

That's because the whole premise of your benchmark relies on a workload that 
yield()s itself to the eyeballs on most graphic card combinations when using 
glxgears. Your test remains a test of sched_yield in the presence of your 
workloads rather than anything else. If people like ck2 it's because in the 
real world with real workloads it is better, rather than on a yield() based 
benchmark. Repeatedly the reports are that 3d apps and games in normal usage 
under -ck are better than mainline and cfs.

--
-ck

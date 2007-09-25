Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXIYInf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXIYInf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXIYIn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:43:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56810 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXIYIn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:43:27 -0400
Date: Tue, 25 Sep 2007 14:23:29 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925085329.GJ26289@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190709207.11226.6.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 10:33:27AM +0200, Mike Galbraith wrote:
> > Darn, have news: latency thing isn't dead.  Two busy loops, one at nice
> > 0 pinned to CPU0, and one at nice 19 pinned to CPU1 produced the
> > latencies below for nice -5 Xorg.  Didn't kill the box though.
> > 
> > se.wait_max              :            10.068169
> > se.wait_max              :             7.465334
> > se.wait_max              :           135.501816
> > se.wait_max              :             0.884483
> > se.wait_max              :           144.218955
> > se.wait_max              :           128.578376
> > se.wait_max              :            93.975768
> > se.wait_max              :             4.965965
> > se.wait_max              :           113.655533
> > se.wait_max              :             4.301075
> > 
> > sched_debug (attached) is.. strange.

Mike,
	Do you have FAIR_USER_SCHED turned on as well? Can you send me
your .config pls?

Also how do you check se.wait_max?

> Disabling CONFIG_FAIR_GROUP_SCHED fixed both.  Latencies of up to 336ms
> hit me during the recompile (make -j3), with nothing else running.
> Since reboot, latencies are, so far, very very nice.  I'm leaving it
> disabled for now.

-- 
Regards,
vatsa

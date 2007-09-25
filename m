Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXIYJAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXIYJAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXIYJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:00:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51500 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXIYJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:00:45 -0400
Date: Tue, 25 Sep 2007 14:41:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925091105.GA1674@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925085329.GJ26289@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925085329.GJ26289@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 02:23:29PM +0530, Srivatsa Vaddagiri wrote:
> On Tue, Sep 25, 2007 at 10:33:27AM +0200, Mike Galbraith wrote:
> > > Darn, have news: latency thing isn't dead.  Two busy loops, one at nice
> > > 0 pinned to CPU0, and one at nice 19 pinned to CPU1 produced the
> > > latencies below for nice -5 Xorg.  Didn't kill the box though.

These busy loops - are they spawned by the same user? Is it the root
user? Also is this seen in UP mode also?

Can you also pls check if tuning root user's cpu share helps? Basically,

	# echo 4096 > /proc/root_user_share

[or any other higher value]

> Also how do you check se.wait_max?

Ok ..I see that it is in /proc/sched_debug.


-- 
Regards,
vatsa

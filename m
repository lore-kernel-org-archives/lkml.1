Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXIYJPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXIYJPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXIYJPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:15:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:53385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750721AbXIYJPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:15:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/vZSl8p8Pv7VD671Gb/LBOFhKJfK9K6DGJf1sqWD
	onhYaAPhS35zV2
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070925091105.GA1674@linux.vnet.ibm.com>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
	 <1190709207.11226.6.camel@Homer.simpson.net>
	 <20070925085329.GJ26289@linux.vnet.ibm.com>
	 <20070925091105.GA1674@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 11:15:18 +0200
Message-Id: <1190711718.13861.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 14:41 +0530, Srivatsa Vaddagiri wrote:
> On Tue, Sep 25, 2007 at 02:23:29PM +0530, Srivatsa Vaddagiri wrote:
> > On Tue, Sep 25, 2007 at 10:33:27AM +0200, Mike Galbraith wrote:
> > > > Darn, have news: latency thing isn't dead.  Two busy loops, one at nice
> > > > 0 pinned to CPU0, and one at nice 19 pinned to CPU1 produced the
> > > > latencies below for nice -5 Xorg.  Didn't kill the box though.
> 
> These busy loops - are they spawned by the same user? Is it the root
> user? Also is this seen in UP mode also?
> 
> Can you also pls check if tuning root user's cpu share helps? Basically,
> 
> 	# echo 4096 > /proc/root_user_share
> 
> [or any other higher value]

I'll try these after I beat on the box some more.

	-Mike


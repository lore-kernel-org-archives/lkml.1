Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYDGMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYDGMZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYDGMZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:25:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:15684 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753842AbYDGMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:25:30 -0400
Subject: Re: [rc8] Regression: key repeats and skips in music during
	compilation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <200804071403.59500.elendil@planet.nl>
References: <200804041222.35025.elendil@planet.nl>
	 <200804071229.27113.rjw@sisk.pl>
	 <20080407112459.GA11532@linux.vnet.ibm.com>
	 <200804071403.59500.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 14:25:15 +0200
Message-Id: <1207571115.15579.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 14:03 +0200, Frans Pop wrote:
> On Monday 07 April 2008, Dhaval Giani wrote:
> > On Mon, Apr 07, 2008 at 12:29:26PM +0200, Rafael J. Wysocki wrote:
> > > On Monday, 7 of April 2008, Frans Pop wrote:
> > > > On Monday 07 April 2008, Rafael J. Wysocki wrote:
> > > > > On Sunday, 6 of April 2008, Rafael J. Wysocki wrote:
> > > > > > On Friday, 4 of April 2008, Frans Pop wrote:
> > > > > > > While compiling glibc I am getting frequent short skips in
> > > > > > > music play anddddddddddddddddd I have now three times seen key
> > > > > > > repeats (as in this sentence). When there is a skip in the
> > > > > > > music, there is also a delay in characters being typed
> > > > > > > appearing on the screen.
> > > > > >
> > > > > > Can you test with CONFIG_GROUP_SCHED unset, please?
> > > > >
> > > > > I was able to reproduce this issue with -rc8 on one of my test
> > > > > systems,
> > > >
> > > > In the mean time I have verified that the issue also existed in rc6,
> > > > so it's not a recent regression.
> > > >
> > > > > but I'm not any more with the current Linus' tree and
> > > > > CONFIG_GROUP_SCHED unset, FWIW.
> > > >
> > > > Hmm. Does that mean that you _can_ reproduce it with git HEAD and
> > > > CONFIG_GROUP_SCHED set? That would mean it is still an issue in HEAD
> > > > and group scheduling is the culprit.
> > >
> > > Well, CONFIG_GROUP_SCHED is known to cause problems, AFAICS, and some
> > > fixes are scheduled for the 2.6.26 time frame.
> >
> > I thought we had most of the issues ironed out.
> 
> Note that I can also reproduce the issue with a kernel that does *not* have 
> CONFIG_GROUP_SCHED set. I still get the music skips (maybe less frequently, 
> but that's hard to measure), and I've have also seen key repeats once.
> 
> Anything I can do to provide additional info on this?

Could you try -rc5 !GROUP ?


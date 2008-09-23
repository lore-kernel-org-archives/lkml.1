Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYIWMKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYIWMKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 08:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYIWMKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 08:10:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:55099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYIWMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:10:14 -0400
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Steigerwald <ms@teamix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200809231401.23432.ms@teamix.de>
References: <200809231101.41624.ms@teamix.de>
	 <200809231348.50834.ms@teamix.de> <20080923115045.GG14840@elte.hu>
	 <200809231401.23432.ms@teamix.de>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 14:10:11 +0200
Message-Id: <1222171811.16700.76.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 14:01 +0200, Martin Steigerwald wrote:
> Am Dienstag, 23. September 2008 schrieb Ingo Molnar:
> > * Martin Steigerwald <ms@teamix.de> wrote:
> > > > please use -p1 to create patches - or since you've just set up the
> > > > tip/master tracking, do something like:
> > >
> > > Okay, lets see how this works out.
> > >
> > > ---
> > > From a57581d4ec3b13f63920b89c336ac9c93c6cf9f0 Mon Sep 17 00:00:00 2001
> > > From: Martin Steigerwald <ms@teamix.de>
> > > Date: Tue, 23 Sep 2008 13:45:46 +0200
> > > Subject: [PATCH] CFS: Documentation about scheduling policies
> >
> > Applied to tip/sched/devel, merged it into tip/master and pushed the
> > result out - thanks Martin.
> >
> > this was a perfect patch :)
> 
> Thanks. Now I can learn how I can update my local tip-master ;-). Hmmm, git 
> pull seemed to do the trick although it did not touch 
> Documentation/scheduler/sched-design-CFS.txt again. Seems it detected that I 
> applied the patch I sent you already.

'git remote update' will be best, 'git pull' only works if the
underlying stuff never gets rebased.



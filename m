Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDGK3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDGK3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYDGK31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:29:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbYDGK31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:29:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
Date: Mon, 7 Apr 2008 12:29:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
References: <200804041222.35025.elendil@planet.nl> <200804071121.03888.rjw@sisk.pl> <200804071205.13369.elendil@planet.nl>
In-Reply-To: <200804071205.13369.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071229.27113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of April 2008, Frans Pop wrote:
> On Monday 07 April 2008, Rafael J. Wysocki wrote:
> > On Sunday, 6 of April 2008, Rafael J. Wysocki wrote:
> > > On Friday, 4 of April 2008, Frans Pop wrote:
> > > > While compiling glibc I am getting frequent short skips in music play
> > > > anddddddddddddddddd I have now three times seen key repeats (as in
> > > > this sentence). When there is a skip in the music, there is also a
> > > > delay in characters being typed appearing on the screen.
> > >
> > > Can you test with CONFIG_GROUP_SCHED unset, please?
> >
> > I was able to reproduce this issue with -rc8 on one of my test systems,
> 
> Thanks Rafael.
> 
> In the mean time I have verified that the issue also existed in rc6, so it's 
> not a recent regression.
> 
> > but I'm not any more with the current Linus' tree and CONFIG_GROUP_SCHED
> > unset, FWIW.
> 
> Hmm. Does that mean that you _can_ reproduce it with git HEAD and 
> CONFIG_GROUP_SCHED set? That would mean it is still an issue in HEAD and 
> group scheduling is the culprit.

Well, CONFIG_GROUP_SCHED is known to cause problems, AFAICS, and some fixes
are scheduled for the 2.6.26 time frame.

Thanks,
Rafael

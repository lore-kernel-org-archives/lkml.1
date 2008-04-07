Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYDGL1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYDGL1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbYDGL0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:26:34 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:59929 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYDGL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:26:33 -0400
Date: Mon, 7 Apr 2008 16:54:59 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during
	compilation
Message-ID: <20080407112459.GA11532@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200804041222.35025.elendil@planet.nl> <200804071121.03888.rjw@sisk.pl> <200804071205.13369.elendil@planet.nl> <200804071229.27113.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804071229.27113.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 12:29:26PM +0200, Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, Frans Pop wrote:
> > On Monday 07 April 2008, Rafael J. Wysocki wrote:
> > > On Sunday, 6 of April 2008, Rafael J. Wysocki wrote:
> > > > On Friday, 4 of April 2008, Frans Pop wrote:
> > > > > While compiling glibc I am getting frequent short skips in music play
> > > > > anddddddddddddddddd I have now three times seen key repeats (as in
> > > > > this sentence). When there is a skip in the music, there is also a
> > > > > delay in characters being typed appearing on the screen.
> > > >
> > > > Can you test with CONFIG_GROUP_SCHED unset, please?
> > >
> > > I was able to reproduce this issue with -rc8 on one of my test systems,
> > 
> > Thanks Rafael.
> > 
> > In the mean time I have verified that the issue also existed in rc6, so it's 
> > not a recent regression.
> > 
> > > but I'm not any more with the current Linus' tree and CONFIG_GROUP_SCHED
> > > unset, FWIW.
> > 
> > Hmm. Does that mean that you _can_ reproduce it with git HEAD and 
> > CONFIG_GROUP_SCHED set? That would mean it is still an issue in HEAD and 
> > group scheduling is the culprit.
> 
> Well, CONFIG_GROUP_SCHED is known to cause problems, AFAICS, and some fixes
> are scheduled for the 2.6.26 time frame.
> 

I thought we had most of the issues ironed out.

/me tries to reproduce.

-- 
regards,
Dhaval

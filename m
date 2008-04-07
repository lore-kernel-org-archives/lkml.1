Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYDGMEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYDGMEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYDGMED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:04:03 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:44829 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbYDGMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:04:03 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
Date: Mon, 7 Apr 2008 14:03:58 +0200
User-Agent: KMail/1.9.9
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200804041222.35025.elendil@planet.nl> <200804071229.27113.rjw@sisk.pl> <20080407112459.GA11532@linux.vnet.ibm.com>
In-Reply-To: <20080407112459.GA11532@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071403.59500.elendil@planet.nl>
X-OriginalArrivalTime: 07 Apr 2008 12:04:00.0209 (UTC) FILETIME=[76EA5C10:01C898A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008, Dhaval Giani wrote:
> On Mon, Apr 07, 2008 at 12:29:26PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 7 of April 2008, Frans Pop wrote:
> > > On Monday 07 April 2008, Rafael J. Wysocki wrote:
> > > > On Sunday, 6 of April 2008, Rafael J. Wysocki wrote:
> > > > > On Friday, 4 of April 2008, Frans Pop wrote:
> > > > > > While compiling glibc I am getting frequent short skips in
> > > > > > music play anddddddddddddddddd I have now three times seen key
> > > > > > repeats (as in this sentence). When there is a skip in the
> > > > > > music, there is also a delay in characters being typed
> > > > > > appearing on the screen.
> > > > >
> > > > > Can you test with CONFIG_GROUP_SCHED unset, please?
> > > >
> > > > I was able to reproduce this issue with -rc8 on one of my test
> > > > systems,
> > >
> > > In the mean time I have verified that the issue also existed in rc6,
> > > so it's not a recent regression.
> > >
> > > > but I'm not any more with the current Linus' tree and
> > > > CONFIG_GROUP_SCHED unset, FWIW.
> > >
> > > Hmm. Does that mean that you _can_ reproduce it with git HEAD and
> > > CONFIG_GROUP_SCHED set? That would mean it is still an issue in HEAD
> > > and group scheduling is the culprit.
> >
> > Well, CONFIG_GROUP_SCHED is known to cause problems, AFAICS, and some
> > fixes are scheduled for the 2.6.26 time frame.
>
> I thought we had most of the issues ironed out.

Note that I can also reproduce the issue with a kernel that does *not* have 
CONFIG_GROUP_SCHED set. I still get the music skips (maybe less frequently, 
but that's hard to measure), and I've have also seen key repeats once.

Anything I can do to provide additional info on this?

Cheers,
FJP

# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set
(config otherwise identical to my initial mail)

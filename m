Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbXGNJkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbXGNJkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 05:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbXGNJkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 05:40:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35033 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbXGNJko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 05:40:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joseph Fannin <jfannin@gmail.com>
Subject: Re: Hibernating To Swap Considered Harmful
Date: Sat, 14 Jul 2007 11:48:17 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707131130.51279.rjw@sisk.pl> <20070714004517.GA18336@nineveh.local>
In-Reply-To: <20070714004517.GA18336@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141148.18279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 July 2007 02:45, Joseph Fannin wrote:
> On Fri, Jul 13, 2007 at 11:30:50AM +0200, Rafael J. Wysocki wrote:
> > On Friday, 13 July 2007 07:42, Joseph Fannin wrote:
> > > On Thu, Jul 12, 2007 at 08:06:43PM -0700, david@lang.hm wrote:
> > > > On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> > >
> > > > > Plus we need to figure out how to avoid corrupting filesystems and
> > > > > swap in use by the "old" kernel and its processes (hint: a separate
> > > > > "hibernation partition" is a no-go).
> > > >
> > > > I thought the existing hibernation wrote to the swap partition as it's
> > > > dedicated space?
> > > >
> > > > I didn't know that anyone was suggesting writing the hibernation image to
> > > > a filesystem that the kernel was activly accessing.
> > >
> > > I'm suggesting a dedicated, preallocated hibernation *file*, right
> > > now.  There's no way around it, if hibernation is to be reliable --
> > > otherwise hibernation can fail if the system has used enough of its
> > > swap space, so that there isn't enough room to write the hibernate
> > > image.
> > >
> > > Even if it's desirable to allow hibernation to fail if the system is
> > > too deep into swap, it's a moot point.
> >
> > If you're afraid of that, use a dedicated swap file.
> 
>     I don't understand what you mean.  A dedicated swap file for what?

Sorry, I should have been more precise.

For hibernation (ie. a swap file that you activate right befor the
hibernation).

Also tuxonice (formerly known as suspend2) allows you to use regular files
hibernation.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

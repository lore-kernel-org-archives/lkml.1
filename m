Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbXLBACV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbXLBACV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXLBACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:02:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbXLBACM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:02:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
Date: Sun, 2 Dec 2007 01:20:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org> <20071201154646.5a288c9e@laptopd505.fenrus.org> <4751F484.6040204@rtr.ca>
In-Reply-To: <4751F484.6040204@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712020120.36439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 2 of December 2007, Mark Lord wrote:
> Arjan van de Ven wrote:
> > On Sat, 01 Dec 2007 18:43:39 -0500
> > Mark Lord <lkml@rtr.ca> wrote:
> > 
> >> Dagnabbit.. it's done it again.. went from 100-200 wakeups/sec
> >> back up to 20000+ wakeups/sec.  This time *with* the powertop patches
> >> in place.
> >>
> >> Somethings broken in there, but I don't know what.
> >> Or how to make it happen on demand.. it's fine after rebooting again.
> >>
> >> ???
> >>
> >> At least now I know to look when I hear the fan turning on
> >> when the system is otherwise supposed to be idle..
> >>
> >> 2.6.23 did not have this problem.
> > 
> > actually we have reports of 2.6.23 having the exact same problem.
> > The thing is, "something" is causing the system to go into a state
> > where the cpu throws us right out of the C-state the kernel asks for.
> ...
> 
> Ahh.  Okay, this machine here did not have the problem on 2.6.23.

So on this particular machine it is a regression.

I'm tempted to add it to the list of recent regressions in case it appears on
someone else's system on which 2.6.23 works correctly.  Objections?

Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbXLWBBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbXLWBBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXLWBBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:01:11 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:61259 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbXLWBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:01:09 -0500
Date: Sat, 22 Dec 2007 19:59:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Willy Tarreau <w@1wt.eu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071222221050.GA20753@1wt.eu>
Message-ID: <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
 <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
 <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
 <20071222192550.GD28891@thunk.org> <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
 <20071222221050.GA20753@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[/me sneaks away from the family]

On Sat, 22 Dec 2007, Willy Tarreau wrote:

> On Sat, Dec 22, 2007 at 01:00:09PM -0800, Linus Torvalds wrote:
> > On Sat, 22 Dec 2007, Theodore Tso wrote:
> > > But sometimes when trying to eyeball what is going on, it's a lot
> > > nicer just to use "cat /proc/slabinfo".
> >
> > .. and I call BS on this claim.
> >

[...]

>
> I can understand that it has to go away for technical reasons, but Ted
> is right, please don't believe that nobody uses it just because you got
> no complaint. While people are not likely to perform all computations
> in scripts, at least they're used to find some quickly identifiable
> patterns there.
>

I know when I'm looking for memory leaks, I've asked customers to give
snapshots of slabinfo at periodic times (once a day even, matters how bad
the leak is). This has been helpful in seeing if something did indeed
leak.

If you have a slab cache that constantly grows, and never shrinks, that's
a good indication that something might be leaking. Not always, since there
can be legitimate reasons for that, but sometimes it helps.

But I still scratch my head when ever I need to touch sysfs.

[/me runs back to the family]

-- Steve


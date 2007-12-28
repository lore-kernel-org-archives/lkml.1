Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXL1OzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXL1OzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 09:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXL1OzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 09:55:10 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:37598 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbXL1OzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 09:55:08 -0500
Date: Fri, 28 Dec 2007 09:52:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Lameter <clameter@sgi.com>,
       Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071228090037.GA20372@elte.hu>
Message-ID: <Pine.LNX.4.58.0712280946430.21091@gandalf.stny.rr.com>
References: <alpine.LFD.0.9999.0712221251110.21557@woody.linux-foundation.org>
 <20071222221050.GA20753@1wt.eu> <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
 <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
 <20071226221631.GD27894@ZenIV.linux.org.uk> <20071228090037.GA20372@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Dec 2007, Ingo Molnar wrote:
>
> or if sysfs/kobjects should be scrapped and rewritten, do you have any
> insight into what kind of abstraction could/should replace it? Should we
> go back to procfs and get rid of kobjects altogether? (as it's slowly
> turning into a /proc problem of itself, with worse compatibility and
> sneakier bugs.)
>

The few times I've used kobjects/sysfs, I would always need to "relearn"
how to use it. It's not trivial at all, and even when I finally get it
working, I'm not sure it's working correctly.

Although something like debugfs took me a few minutes to use. Now when
ever I need to do something that userspace uses, I simply choose debugfs.

I thought the switch to sysfs was to keep procfs cleaner and only used for
processes. Why did it need something so complex as the kobject structure?
Was it so that udev could integrate with it? If sysfs was as simple as
debugfs, I think a lot of these bugs would not have occurred.

-- Steve


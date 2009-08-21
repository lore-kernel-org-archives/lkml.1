Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZHUOyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZHUOyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbZHUOyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:54:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34741 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbZHUOye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:54:34 -0400
Date: Fri, 21 Aug 2009 16:54:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090821145406.GA3659@elte.hu>
References: <20090819025634.987354707@goodmis.org> <20090821143525.GH11098@elte.hu> <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 21 Aug 2009, Ingo Molnar wrote:
> > 
> > btw., the way i tested this in the past (and which i dont have time 
> > to test right now) is that i took a plain Fedora box with a regular 
> > rpm kernel booted up and typed:
> > 
> > 	make localyesconfig
> > 
> > and built it and then 1) checked the size of the .config (it should 
> > be much smaller than allyesconfig) and 2) tried to boot the 
> > resulting bzImage.
> 
> Did you check the size without the # comments?

hm, i dont remember precisely - but maybe i only considered the size 
of the file. Your patch would expand everything and then turn off 
the leafs, leaving a large (but still small ;-) .config in place, 
right?

> > It either didnt boot in the past, or had a very large .config. 
> > It would be nice if you could check whether it does on a box of 
> > yours. (maybe you already did that!)
> 
> I went back to your old config and I could not reproduce it. But I'll try 
> again with a new kernel rpm, and do the following:
> 
> # rpm -Uvh <some new kernel>
> # reboot    # to that new kernel
> $ git clone <latest-linus.git> linus.git
> $ cd linus.git
> $ make localyesconfig
> 
> and see what happens. Is this a good test for you?

Yes, of course. The whole patch-set is lovely and the sooner we put 
this upstream the better.

	Ingo

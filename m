Return-Path: <linux-kernel-owner+w=401wt.eu-S1031428AbXD2Wha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031428AbXD2Wha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031443AbXD2Wh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:37:29 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:56531 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031428AbXD2Wh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:37:28 -0400
Date: Mon, 30 Apr 2007 00:36:49 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20070429223649.GA12672@linuxtv.org>
References: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org> <20070429210505.GS3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429210505.GS3468@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.103.156
Subject: Re: Linux 2.6.21
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007, Adrian Bunk wrote:
> On Sun, Apr 29, 2007 at 01:33:16PM -0700, Linus Torvalds wrote:
> > On Sun, 29 Apr 2007, Adrian Bunk wrote:
> > > 
> > > The kernel Bugzilla currently contains 1600 open bugs.
> > 
> > Adrian, why do you keep harping on this, and ignoring reality?
> > 
> > Kernel bugzilla has 1600 open bugs BECAUSE IT SUCKS.
> 
> OK, how do you suggest to track bugs in a way that doesn't suck?
> 
> Bug reports to linux-kernel have the big problem that they are lost if 
> no developer immediately picks them up.

I suspect some bug reports get ignored deliberately.

Why? Because it's hard to write good bug reports, and thus
a lot of them suck.

In some cases you are lucky and get a test case which makes
the bug easily reproducible, or you get a nice, comprehensible
Oops message, and can pinpoint the bug right away. But usually you
have to interact with the user to get more information, have her
try various patches or do a bisect. And sometimes this interaction
drives you crazy because the user is slow to answer, gives you
incomplete or even false information, and doesn't do what you
ask her to do to narrow the bug, or you just have no clue
what the bug could be etc.

Probably every developer went through this experience a couple of
times, wasting a lot of time and causing a lot of grief. Thus it's
just natural that you learn from the experience to ignore every
bug report which even remotely smells fishy ;-/
Y'know, a lot of developers don't just work for the money, they
work for the fun of it. Thus they try to avoid pain and grief. :-)

Bugzilla just makes this visible because it doesn't forget.
Which is stupid and discouraging for both (potential) bug
reporters and developers.


The lesson to learn is that there are some very valid
reasons why bug reports get ignored (some not mentioned here),
and there's nothing you can do about it. And it has nothing to
do with the method or tool used for reporting or tracking.

And I also think that ignoring bad bug reports _increases_
the software quality, because you can use the saved time
working on something productive. And it makes developers
happier :-)

[Just to avoid misunderstandings: By no means do I advocate
ignoring *every* bug report. But ignoring the bad ones
is just the sane thing to do.]


Johannes

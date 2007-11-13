Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbXKMV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbXKMV60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759425AbXKMV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:58:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135AbXKMV6K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:58:10 -0500
Date: Tue, 13 Nov 2007 13:56:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?SvZybg==?= Engel <joern@logfs.org>
Cc: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       protasnb@gmail.com, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113135658.5c9ac7ba.akpm@linux-foundation.org>
In-Reply-To: <20071113213358.GC20167@lazybastard.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<20071113.033946.114918709.davem@davemloft.net>
	<20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
	<20071113041259.79c9a8c5.akpm@linux-foundation.org>
	<20071113134029.GA30978@elte.hu>
	<4739AFE0.20705@rtr.ca>
	<20071113193750.GD1356@flint.arm.linux.org.uk>
	<473A067F.3090007@rtr.ca>
	<20071113213358.GC20167@lazybastard.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 22:33:58 +0100 Jörn Engel <joern@logfs.org> wrote:

> On Tue, 13 November 2007 15:18:07 -0500, Mark Lord wrote:
> > 
> > I just find it weird that something can be known broken for several -rc*
> > kernels before I happen to install it, discover it's broken on my own 
> > machine,
> > and then I track it down, fix it, and submit the patch, generally all 
> > within a
> > couple of hours.  Where the heck was the dude(ess) that broke it ??  AWOL.
> > 
> > And when I receive hostility from the "maintainers" of said code for fixing
> > their bugs, well.. that really motivates me to continue reporting new ones..
> 
> Given a decent bug report, I agree that having the bug not looked at is
> shameful.  But what can a developer do if a bug report effectively reads
> "there is some bug somewhere in recent kernels"?  How can I know that in
> this particular case it is my bug that I introduced?  It could just as
> easily be 50 other people and none of them are eager to debug it unless
> they suspect it to be their bug.

It's relatively common that a regression in subsystem A will manifest as a
failure in subsystem B, and the report initially lands on the desk of the
subsystem B developers.

But that's OK.  The subsystem B people are the ones with the expertise to
be able to work out where the bug resides and to help the subsystem A
people understand what went wrong.

Alas, sometimes the B people will just roll eyes and do nothing because
they know the problem wasn't in their code.  Sometimes.

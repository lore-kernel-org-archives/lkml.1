Return-Path: <linux-kernel-owner+w=401wt.eu-S934519AbXJOUIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbXJOUIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934246AbXJOUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:08:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22217 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934438AbXJOUI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:08:27 -0400
Subject: Re: [PATCH] RT: fix spin_trylock_irq
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0710151406230.26495@gandalf.stny.rr.com>
References: <20071011142417.1d965820@bull.net>
	 <Pine.LNX.4.58.0710111046170.20114@gandalf.stny.rr.com>
	 <1192470246.17527.15.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0710151406230.26495@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 13:06:56 -0700
Message-Id: <1192478816.17527.58.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 14:14 -0400, Steven Rostedt wrote:

> > This is the second fix for this .. The first was in this email (over a
> > month ago)
> >
> > http://lkml.org/lkml/2007/8/31/318
> 
> You're right I missed that. (I even read it). But for fixes like this, (or
> any patches that are not in the tree), you really need to resend the
> series.

In hindsight I should have resent, but I didn't .. Really it's a matter
of frustration on my part. Where I submit patches that should be
included , but they are ignored for no clear reason .. Then I submit
again, and the patches are ignored again for no clear reason..

Comparing mainline and -rt isn't very interesting since , -rt has few
patches sent in against it .. Andrew is bound to loose a patch here and
there on accident, but -rt has so few patches sent in that we shouldn't
be loosing any.

> When Ingo posts patches to LKML on CFS, if there's a little fix like this,
> he'll add that to his next queue and repost.

That's a git tree tho , so apples and oranges ..

> >
> > The above was emailed to Thomas, but I also sent you that link in IRC as
> > a link of patches to include .. I'll be happy to audit my code better,
> > but you should also audit your inclusion process better.. There have
> > been too many missed patches, and too many double and triples fixes..
> 
> There wouldn't be if we didn't have to go looking for patches on patches
> that are out of the series. If you see that a series is broken, don't
> patch against it. Resend the series!

In all fairness you asked for links to patches, and that's is what I
gave you ..

> Patches must be against upstream, unless they are more RFC (like what
> Gregory is doing). But when you want them to go upstream, they must be
> against upstream.  I don't have the time to look for little fixes that
> you've done to your own patches that have not been pulled in yet.

Not sure what your getting at.. I specifically directed you to a patch.
I don't think that means you had to look for it, all you have to do was
include it ..

Daniel


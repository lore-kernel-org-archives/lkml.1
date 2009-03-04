Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZCDAoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZCDAoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZCDAoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:44:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33987 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZCDAoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:44:15 -0500
Date: Wed, 4 Mar 2009 01:47:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090304004701.GB6280@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902282353.39763.rjw@sisk.pl> <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com> <200903011020.53130.rjw@sisk.pl> <d6200be20903021722y7f085482o66f6dee8c4004acd@mail.gmail.com> <20090303135143.GA5060@elf.ucw.cz> <d6200be20903031606k338168d2g2f012965a197fe5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20903031606k338168d2g2f012965a197fe5c@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-03 16:06:02, Arve Hj?nnev?g wrote:
> On Tue, Mar 3, 2009 at 5:51 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> >> > Not ignoring, but considering them as insufficient.  And since they've already
> >> >> > been considered as insufficient, there's no point repeating them over and over
> >> >> > again.  That doesn't make them any better.
> >> >>
> >> >> The problem is that what you consider insufficient is what allows us
> >> >> to ship a product.
> >> >
> >> > This doesn't matter a whit, because the mainline kernel is not just your
> >> > product.
> >>
> >> Unless you are saying that changes in the mainline kernel does not
> >> need be usable in practice, then it does matter. If we remove the
> >> feature that allows us to interact with existing code, it will take
> >> much longer before it is usable by anyone.
> >
> > Well, taking longer before "being usable" is good tradeoff if it means
> > "we get cleaner/actually correct system in mainline sooner".
> 
> I think this could go either way. If the system is usable, it may get
> more use from developers that know how to improve a specific subsystem
> to not use timeouts. Or, it may be considered good enough, and nobody
> bothers coming up with a correct solution. I think the latter is what
> you are worried will happen.

Yep.

> >> I submitted them three weeks ago. I'll submit a new set after I rename
> >> the api (presumably to suspend_block(er)) but I would like more
> >> agreement on the timeout issue first.
> >
> > I do believe that everyone (including you :-) agrees that timeouts are
> > ugly hack. So just reorder the series so they come at the end.
> 
> No, I think many uses of timeouts are a ugly hack, not all, but OK I
> will try to move timeout support to a separate patch.

Thanks.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

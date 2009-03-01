Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZCAXF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZCAXF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZCAXFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:05:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46494 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZCAXFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:05:49 -0500
Date: Mon, 2 Mar 2009 00:08:30 +0100
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
Message-ID: <20090301230830.GF1961@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902281118.14595.rjw@sisk.pl> <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com> <200902282353.39763.rjw@sisk.pl> <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20902281606g1c5db332r9970931d7080717f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > I do realize that you consider your current solution as the best thing since
> >> > the sliced bread, but please accept the fact that the other people think
> >> > differently.
> >>
> >> I certainly do not think my current solution is the best, it is very
> >> invasive. I do however think your proposed solution is worse. The only
> >> proposed alternative that we could actually ship a product on today is
> >> to not use suspend at all.
> >
> > Well, I'm sure your code is useful for the Android platform, but the question
> > is whether we want this code in the mainline kernel.  For now, the answer is
> > "no, we don't".  Moreover, since you're the one who wants the code to be
> > merged, it's your burden to make it acceptable for us.  However you're going
> > to do it is up to you, but certainly trying to force your current code on us
> > is not going to work.
> 
> I don't think I am the only one who want this code in the mainline
> kernel. Many people want to use the android platform, and support in
> the mainline kernel would be beneficial to some of them. I made many
> requested changes to my code that provides no benefit to us, but I
> have not made any changes that breaks our own use.

No, you are not the only one. OTOH... that can't be used as an
argument to get it into kernel "as is".

Yes, I'd like to see it in but yes, I understand and agree with (most)
Rafaels's concerns.

> > BTW, I think you handled the thing wrong.  If I were you, I wouldn't even try
> > to push the code as you did.  I would instead make it as simple as reasonably
> > possible so that the basic idea was clear and understandable to everyone.
> > Then, if there were any doubts with respect to the basic idea, I'd try to
> > clarify them and I'd consider modifying the code to address objections.
> > I'd only try to add more features after the basic idea had been accepted.
> 
> The basic concept was developed long before android was a public project.

That's not our fault... 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

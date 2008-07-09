Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYGIU50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYGIU50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYGIU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:56:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1557 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755595AbYGIU4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:14 -0400
Date: Wed, 9 Jul 2008 22:14:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Oliver Neukum <oliver@neukum.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080709201447.GC11006@ucw.cz>
References: <20080704063455.GA13999@digi.com> <200807040852.27809.oliver@neukum.org> <m3k5g1zv3u.fsf_-_@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3k5g1zv3u.fsf_-_@maximus.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-07-04 14:34:13, Krzysztof Halasa wrote:
> Oliver Neukum <oliver@neukum.org> writes:
> 
> >> I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> >> the corresponding region the alphabetic ordering is broken.  Then I
> >> inteded to fix that up for a trivial patch.  Next was to check the rest
> >> of the file and there are so much misorderings that it's not sensible to
> >> choose the trivial path anymore as there are currently 114 entries out
> >> of order[1].
> >
> > What good does alphabetic ordering? You'll grep it anyway.
> 
> I was thinking about a mailing list / database service instead:
> - source file/directory-based (e.g. someone could maintain whole
>   drivers/, someone else drivers/char and others drivers/char/asdfg.[ch])
> - people would be able to add themselves as "observers" using mail
>   and/or HTML interface
> - sending a patch would automatically trigger Cc: to all people
>   registered as maintainers (or "observers") for the files modified
> - full recipient list would be present in mail sent by the service, so
>   the following discussion wouldn't need it anymore. It would be used
>   only for posting patches.
> - as such, I don't expect a need for spam filtering - messages
>   containing no patch would be rejected in the SMTP session.
> 
> Pro: no more missing Cc:, no more manual lookups and guessing, you
>      just Cc: the service, possibility for "observers".
> Con: another thing to create and maintain, you don't immediately know
>      who exactly has been sent a copy.
> 
> I think I could create a test service but after the test phase it
> should probably go to some machine more reliable/able than mine.

If something like that existed/was useful, I guess finding hosting
would not be huge problem.

And yes, I like the idea.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

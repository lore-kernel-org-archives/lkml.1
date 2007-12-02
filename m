Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbXLBOPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbXLBOPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 09:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbXLBOPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 09:15:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4531 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753503AbXLBOPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 09:15:45 -0500
Date: Sun, 2 Dec 2007 14:15:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Dan Kegel <dank@kegel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Relax permissions for reading hard drive serial number?
Message-ID: <20071202141535.GA4721@ucw.cz>
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> http://marc.info/?l=linux-kernel&m=96836765403118&w=2, Linus wrote:
> > Hmm.. I have this feeling that it would be much nicer to
> > just implement the NT system calls directly.
> > ...
> > I wouldn't be adverse to supporting Wine better...
> 
> A few years on, Wine has matured to the point where it's
> ready to run quite a few apps, even some protected by Safedisc.
> One sticking point is that apps like Photoshop and probably
> Punkbuster want to retrieve the hard drive's serial number,
> but Linux restricts access to that info:
> $ ls -l /proc/ide/hda/identify
> -r-------- 1 root root 0 2007-11-29 07:05 /proc/ide/hda/identify
> (And even if /proc/ide goes away, the other ways of retrieving
> this info are similarly restricted to root.)
> 
> Any reason the access control on this info shouldn't be eased a bit,
> e.g. make /proc/ide/*/identify be mode 444?

I think conslusion was 'unchangeable machine ids are root-only'. But
perhaps you can chmod in startup scripts?

> An alternative might be for Wine to simply fake the serial number,
> but I would like to avoid that if possible.

Fake it, I'd say.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

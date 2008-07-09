Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYGIUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYGIUzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYGIUzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:55:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1518 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751504AbYGIUze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:55:34 -0400
Date: Wed, 9 Jul 2008 22:29:20 +0200
From: Pavel Machek <pavel@suse.cz>
To: Felipe Balbi <felipebalbi@users.sourceforge.net>
Cc: Theodore Tso <tytso@mit.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
Message-ID: <20080709202920.GE11006@ucw.cz>
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com> <20080705133601.GA20240@mit.edu> <31e679430807050700q765dc45ft198fcf1c0b91a9cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31e679430807050700q765dc45ft198fcf1c0b91a9cc@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > You didn't say which battery you are using; I'm guessing you are using
> > the 4 cell slim-line battery, which is rated at 28.8 Watt-hours?
> 
> yeah, the normal slim-battery.
> 
> > How many Watts is Powertop reporting that you are using?  I'm down to
> 
> eheh, it's only 15.5w :-p
> 
> > around 8-9 watts, and around 9.5 watts in "airplane mail reading mail"
> > (wireless disabled, USB modules unloaded, screen brightness turned way
> > down, laptop_mode enabled, all mail messages pulled into memory, and
> > reading/deleting mail using mutt, a character-mode based mail reader
> > --- if you use Evolution, your energy usage will definitely be higher  :-).
> 
> no crappy evolution, I use fluxbox and mutt. This ubuntu machine is
> for testing purposes only :-p
> 
> Anyways, it's bad that we have to manually unload several modules,
> specially usb. I'm sure windows reaches 9 watts consumption without
> breaking functionality. And that's the big thing. I think that's something
> we should be aiming. Dontcha think?

Can you test Ted's suggestion to see if we have nailed the problem,
first?

9W vs. 15W does not explain 1h30 vs 3h30 difference, afaict.

(Of course, we are working on usb autosuspend. Try 2.6.26).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S968744AbXG3V1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968744AbXG3V1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968207AbXG3V03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:26:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56934 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967421AbXG3V02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:26:28 -0400
Date: Mon, 30 Jul 2007 23:26:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Richard Hughes <hughsient@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND
Message-ID: <20070730212608.GB22419@elf.ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <200707292336.55588.rjw@sisk.pl> <1185744640.2295.4.camel@work> <200707300022.54633.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707300022.54633.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Not only.  This also includes "standby".
> > > > 
> > > > Whatever it includes - please tell it to the user in the prompt.
> > > > 
> > > > Technical issues are important, but it's often forgotten how many 
> > > > problems people run into because the description of a kconfig option 
> > > > could have been better.
> > > 
> > > Sure.  Please see the updated patch I've just sent. :-)
> > 
> > So are you guys using:
> > 
> > "standby" = idle state, ~0.5 seconds
> > "suspend" = sleep to ram, ~10 seconds
> > "hibernate" = sleep to disk, ~30 seconds
> 
> Something like this, but "suspend" is not reserved as a name of specific state.
> 
> The second state is usually referred to as "suspend to RAM" or "STR" and is
> denoted by "mem" in /sys/power/state, if implemented.  Moreover, "standby" and
> "mem" are both entered using the same code path, so they may generally be
> referred to as "suspend" states.
> 
> The times aren't strictly defined for "mem" and "standby", too.  The general
> rule is that the times for "mem" are greater then for "standby" and the power
> drawn in "mem" is smaller than the power drawn in "standby", but the exact
> values will always depend on the platform.  Apart from this, if the platform
> supports only one "suspend" state, it decides if that's "mem" or "standby".
> 
> On ACPI systems "standby" and "mem" correspond to the S1 and S3 sleep states,
> respectively.

And I'd expect ~2seconds for both "standby" and "mem" on ACPI
system. ACPI S1 is just "for windows ME compatibility, do not use" --
it draws too much power, and is not really faster.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

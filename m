Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbXHFLrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbXHFLrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXHFLrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:47:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXHFLrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:47:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
Date: Mon, 6 Aug 2007 13:56:22 +0200
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
References: <200708051906.22865.rjw@sisk.pl> <1186398917.28655.69.camel@johannes.berg> <20070806113644.GA1790@elf.ucw.cz>
In-Reply-To: <20070806113644.GA1790@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061356.23030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 13:36, Pavel Machek wrote:
> On Mon 2007-08-06 13:15:17, Johannes Berg wrote:
> > On Mon, 2007-08-06 at 12:26 +0200, Pavel Machek wrote:
> > 
> > > Well, so that it does not bitrot? This is few bytes, I'd say, and I
> > > believe we have too many config options already.
> > 
> > This is not an option the user is ever going to see. I think I'd
> > prefer
> 
> Ok, option that users can't set is probably not evil.
> 
> > having two new per-ARCH config symbols though:
> > config SUSPEND_UP_POSSIBLE
> > 	depends on ARCH_SUSPEND_UP_POSSIBLE
> > 
> > and then the architecture gets to define that when it can suspend.
> 
> Looks like a plan.

Hmm, why don't we do the $subject change first (the advantage if it is that
the patch is ready) and then move the necessary definitions to the arch level?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

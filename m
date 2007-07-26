Return-Path: <linux-kernel-owner+w=401wt.eu-S936598AbXGZUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936598AbXGZUjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934382AbXGZUjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:39:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764714AbXGZUjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:39:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1)
Date: Thu, 26 Jul 2007 22:48:08 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262248.09187.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 July 2007 21:57, Linus Torvalds wrote:
> 
> On Thu, 26 Jul 2007, Rafael J. Wysocki wrote:
> > 
> > Hmm, perhaps we should introduce a CONFIG_SUSPEND and change
> > CONFIG_SOFTWARE_SUSPEND into CONFIG_HIBERNATION, both depending on
> > CONFIG_PM?
> > 
> > There's quite some code needed only for suspend compiled in when CONFIG_PM is
> > set ...
> 
> Sounds like a good idea, although I suspect that CONFIG_PM really *is* 
> fairly close to CONFIG_SUSPEND. The thing is, all the stuff it enabled is 
> largely useless without at least STR.

My point is we have ACPI dependent on PM, so if you want ACPI, you end
up with all of the STR stuff built in, which is what you don't like (if I
understand that correctly).  If we have CONFIG_SUSPEND, you'll be able to
choose ACPI alone. :-)

> (Yes, I realize that you can do per-driver suspend events etc, but I 
> suspect not a lot of people have used it).
>
> But from a logical standpoint, it does make sense to have a separate 
> config option for the STR support.

Exactly.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

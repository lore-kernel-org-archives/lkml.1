Return-Path: <linux-kernel-owner+w=401wt.eu-S935626AbXGQUwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935626AbXGQUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759413AbXGQUuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:50:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934514AbXGQUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:50:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 22:58:33 +0200
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm> <87k5syg3yi.fsf@jbms.ath.cx>
In-Reply-To: <87k5syg3yi.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172258.35113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 22:39, Jeremy Maitin-Shepard wrote:
> david@lang.hm writes:
> 
> [snip]
> 
> > the non-ACPI hibernate behaves very differently, and for some people (and I
> > think I am one of them) it will meet their needs better then _any_ of the ACPI
> > suspends.
> 
> It may have certain differences from the user point of view, but from
> the implementation view, it seems that it is nearly exactly the same.
> The only differences seem to be: 
> 
>  - rather than shutting down, do whatever is necessary to stick the
>    system in S4 state.
> 
>  - make sure ACPI isn't initialized by the "load image" kernel
> 
>  - rather than "resume from hibernate" ACPI by initializing it normally,
>    issue the special hibernate-related methods.
> 
> Thus, it seems that supporting ACPI S4 will have a very minimal affect
> on the hibernate implementation.

Still, you need to take it into account.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

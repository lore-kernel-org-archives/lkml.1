Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbXGBLwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbXGBLwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXGBLwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:52:05 -0400
Received: from mail.suse.de ([195.135.220.2]:40501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbXGBLwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:52:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: blink driver power saving
Date: Mon, 2 Jul 2007 13:51:57 +0200
User-Agent: KMail/1.9.6
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "" Dmitry Torokhov "" <dtor@insightbb.com>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
In-Reply-To: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021351.57965.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 13:43:23 Indan Zupancic wrote:
> On Mon, July 2, 2007 01:59, Andi Kleen wrote:
> > Well only those that could be already hung from user space
> > with setleds (that was also confirmed).  Actually I thought
> > they didn't hang completely, but just stopped reacting to
> > the keyboard (which is actually pretty bad for every user
> > to be able to trigger)
> 
> Pavel's lost key events, mine stopped reacting altogether.

Did you try if the network was still alive? Perhaps it was
just a locked up keyboard.

> 
> > I guess the better way to handle those would be to find out the
> > minimum frequency of blinking that is still ok and rate limit it to that in
> > the keyboard driver.
> 
> Dmitry already has a patch for that. He limited it to one event each 50 ms.

Great.

> 
> > Anyways, Stephen's patch just doesn't make sense:
> > he clearly didn't understand the code at all. Before you
> > apply it and cripple it better drop the driver completely.
> 
> CC'ing Dmitry, as I think he doesn't like the blink driver much either. ;-)

Perhaps one of you geniuses who all hate it can find a better way to 
solve the "video output dead after kexec; but need visual feedback to the user
while crash dumping" problem. I'm waiting for your patches.

-Andi

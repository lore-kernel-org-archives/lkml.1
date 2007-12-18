Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbXLRCeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbXLRCeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbXLRCeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:34:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:45399 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXLRCeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JEKRrNNvS5A01jw1vLE/bL+pcjWm//FLi1r1s01pg0jgnZgLZDqpATpEn8C95doL+zVj36kfYpteT1Twt7n3wZGhxmSX+z7f7OIBlgR0N+x22H/UNcuNN5PsAhPDlYlDSmvequDxG0vbXLCqtmDrfaT2cE+GY9piddWS+8SYRN0=
Message-ID: <520b60a90712171834n61b09f23rc4c907ce3e8458cf@mail.gmail.com>
Date: Mon, 17 Dec 2007 21:34:13 -0500
From: mvtodevnull@gmail.com
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Michael Buesch" <mb@bu3sch.de>,
       "Daniel Walker" <dwalker@mvista.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <47671F5F.5020400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <47633BAE.6040604@lwfinger.net>
	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>
	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
	 <47637FDA.2030303@lwfinger.net>
	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>
	 <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>
	 <47661CA1.3080808@lwfinger.net>
	 <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
	 <47671F5F.5020400@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 8:16 PM, Larry Finger <larry.finger@lwfinger.net> wrote:
>
> I hope that you have now convinced yourself that you should be using b43 and not messing around
> forcing b43legacy to use a device for which it was not intended.
>

I was convinced the moment I realized it worked exactly the same as
b43 (if they work the same, I'd rather use the intended driver). The
b43legacy test was more out of desperation than anything serious. I
thought I should share though, since my original question was about
the firmware and because the difference between versions (or lack
thereof) had been discussed in this thread.

> You should concentrate on what in your environment changed when you rebooted. If you can get the 200
> kBs rate back, please note the noise and signal levels as compared to the values when you are
> restricted to 40 kBs.
>

Really, the only thing that might have changed is some things that may
have caused noise were turned off -- in other words, there should have
been more noise with the 200 kB/s, but of course that doesn't make
sense. It should be noted though that even at 200 kB/s, the b43 driver
was operating at less than half the speed of bcm43xx. That being said,
I've been trying very hard to repeat this, but cannot. I'll keep
trying though, and make sure to note everything possible if it ever
happens again.

> Is it possible for you to test your laptop on another AP?
>

Not currently, but I'll try to find a way to do so -- not sure how
long it'll take.

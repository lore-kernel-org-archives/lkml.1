Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbXEYAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbXEYAjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXEYAjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:39:23 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXEYAjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:39:23 -0400
Date: Thu, 24 May 2007 17:37:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <20070524231852.GG9604@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
 <1180008394.15600.26.camel@localhost> <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
 <20070524200435.GA9604@elf.ucw.cz> <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
 <20070524220017.GC9604@elf.ucw.cz> <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
 <20070524221743.GD9604@elf.ucw.cz> <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
 <20070524231852.GG9604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Pavel Machek wrote:
> 
> 2) we need to preload firmware during _suspend_. I AM TELLING THAT TO
> PEOPLE FOR FIVE YEARS NOW.

And people aren't listening. Have you thought about _why_?

The thing is, it should just work. Even without pre-loading.

> Imageine we killed freezer. Also imagine Romano has IDE card his
> PCMCIA slot. Kaboom, we solved nothing.

Don't be silly. We solved it. The firmware has to be loadable from 
somewhere else, since otherwise his IDE card wouldn't have been accessible 
in the first place! 

So all your arguments are just bogus crap.

			Linus

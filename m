Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXE2Gza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXE2Gza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXE2GzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:55:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:36634 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXE2GzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RvP4wY1aeMWW97UOW6+UOwtLGUdR/zN4gkatC39v52BV2jAXM661aVvQofez3EGaTw4hVjexi8LLVQiPP8r1CRCKmuf+C5lrH4k0IQtSAVK6rahhafIO/kTbU3yqCHkrbd4+LnF4yw8EeJXz5voqt1i92YXWdndu2pLu8vvj3Iw=
Message-ID: <3ae72650705282355j40a0b03bt96661bc1263efc35@mail.gmail.com>
Date: Tue, 29 May 2007 08:55:20 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Cc: "Pavel Machek" <pavel@ucw.cz>, "Romano Giannetti" <romanol@upcomillas.es>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
	 <20070524200435.GA9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
	 <20070524220017.GC9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
	 <20070524221743.GD9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
	 <20070524231852.GG9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
X-Google-Sender-Auth: e1f48f33a39a3fb5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, 25 May 2007, Pavel Machek wrote:
> >
> > 2) we need to preload firmware during _suspend_. I AM TELLING THAT TO
> > PEOPLE FOR FIVE YEARS NOW.
>
> And people aren't listening. Have you thought about _why_?
>
> The thing is, it should just work. Even without pre-loading.
>
> > Imageine we killed freezer. Also imagine Romano has IDE card his
> > PCMCIA slot. Kaboom, we solved nothing.
>
> Don't be silly. We solved it. The firmware has to be loadable from
> somewhere else, since otherwise his IDE card wouldn't have been accessible
> in the first place!

The shiny userspace firmware loading causes problems since it exists,
every second box has problems with it, in all sorts of situations. If
people are still sold to the idea of userspace firmware loading, why
don't we keep the data in the driver, instead of immediately
discarding it after the first upload? Not to waste a few hundred
kilobytes? That doesn't sound like a convincing deal, after all the
years people try to work around the issues it causes.

Kay

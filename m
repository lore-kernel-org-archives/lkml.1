Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbXJLMSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbXJLMSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXJLMS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:18:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:36584 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXJLMS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ToGTnNKHFPZxXVfN6HerajEBT5dokiKBAYa/G1QpIk40rWLlG5IRb/dVP10HQ4auDayAN/lySfeRqkWA0GH53teo+vXIofw9gYCTqu98W4ply8VYFrDE9ldub14SC+7ezgYy1oHcE3Y7CYmBjoAMjGGt+z92VYohi5LqmQ9zzC8=
Message-ID: <3ae72650710120518p6132e459q7ee234d640ad0a1c@mail.gmail.com>
Date: Fri, 12 Oct 2007 14:18:26 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [GIT PULL] MMC updates
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <20071012074556.574584db@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
	 <alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
	 <20071012074556.574584db@poseidon.drzeus.cx>
X-Google-Sender-Auth: e8dc1b9862795ee0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Thu, 11 Oct 2007 22:30:41 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> >
> > There seems to be some breakage here:
> >
> >       drivers/mmc/core/host.c: In function 'mmc_remove_host':
> >       drivers/mmc/core/host.c:146: error: implicit declaration of
> > function 'led_trigger_unregister' drivers/mmc/core/host.c:146: error:
> > 'struct mmc_host' has no member named 'led'
> >
> > this was after doing a few "make randconfig" runs, a habit I'm trying
> > to encourage (and do myself occasionally too).
> >
>
> How embarrassing. I'll have a look at it and reping you when I've
> solved it.

I see the same here. MMC needs a dependency on LEDS_TRIGGERS, I guess.

Kay

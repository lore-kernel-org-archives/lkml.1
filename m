Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYENCeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYENCeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYENCeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 22:34:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:51495 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYENCeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 22:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=spvh7wcFJQ3kOg5AagnWv/fMHUtrr6ums++0FjFN/KgmOKja+x6/hMOw6J39sKWH9btvTJ8Ojkbi3nc2dPmFKROqtA7Si7TZi/PnZBHTD2tKw5gmnRUgtesmvEdDFJ8ATaYX81w6O4T2gNZ9se6X5/qLsC66EwaufOV2UtCY4Bw=
Message-ID: <37219a840805131934j4d35b56at1e90fbd26446e022@mail.gmail.com>
Date: Tue, 13 May 2008 22:34:13 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 01/37] V4L/DVB (7473): PATCH for various Dibcom based devices
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Hans-Frieder Vogt" <hfvogt@gmx.net>,
       "Felix Apitzsch" <F.Apitzsch@soz.uni-frankfurt.de>,
       "Antti Palosaari" <crope@iki.fi>,
       "Albert Comerma" <albert.comerma@gmail.com>,
       "Patrick Boettcher" <pb@linuxtv.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Michel Morisot" <mmorisot.abonnement@belcenter.com>
In-Reply-To: <20080514020333.GA30079@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513200453.064446337@mini.kroah.org>
	 <20080513201053.GA31167@suse.de> <20080513201120.GB31167@suse.de>
	 <37219a840805131827v5faf7710pf0b3f67e570bdc7f@mail.gmail.com>
	 <20080514020333.GA30079@suse.de>
X-Google-Sender-Auth: c7dba78469c606c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:03 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, May 13, 2008 at 09:27:30PM -0400, Michael Krufky wrote:
>  > On Tue, May 13, 2008 at 4:11 PM, Greg KH <gregkh@suse.de> wrote:
>  > > 2.6.25-stable review patch.  If anyone has any objections, please let us know.
>  > >
>  > >  ------------------
>  > >
>  > >  From: Albert Comerma <albert.comerma@gmail.com>
>  > >
>  > >  patch 6ca8f0b97473dcef3a754bab5239dcfcdd00b244 upstream
>  > >
>  > >  This patch introduces support for dvb-t for the following DiBcom based cards:
>  > >
>  > >  - Terratec Cinergy HT USB XE (USB-ID: 0ccd:0058)
>  > >  - Terratec Cinergy HT Express (USB-ID: 0ccd:0060)
>  > >  - Pinnacle 320CX (USB-ID: 2304:022e)
>  > >  - Pinnacle PCTV72e (USB-ID: 2304:0236)
>  > >  - Pinnacle PCTV73e (USB-ID: 2304:0237)
>  > >  - Yuan EC372S (USB-ID: 1164:1edc)
>  > >
>  > >  Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
>  > >  Signed-off-by: Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>
>  > >  Signed-off-by: Antti Palosaari <crope@iki.fi>
>  > >  Signed-off-by: Albert Comerma <albert.comerma@gmail.com>
>  > >  Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
>  > >  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>  > >  Cc: Michel Morisot <mmorisot.abonnement@belcenter.com>
>  > >  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>  > >
>  > >  ---
>  > >   drivers/media/dvb/dvb-usb/dib0700_devices.c |  259 ++++++++++++++++++++++++----
>  > >   drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    9
>  > >   2 files changed, 238 insertions(+), 30 deletions(-)
>  >
>  >
>  > This patch is entirely inappropriate for -stable
>
>  Why do you say that?  It adds new device ids for devices to a driver,
>  which is find for stable.

It is much larger than a 100 line patch.  I know that this is not a
_strict_ requirement, but upon closer inspection, I see that the
majority of this is codingstyle cleanup.  The codingstyle cleanups
should have been removed from this patch before backporting to
-stable, in my opinion.

>  > I usually send in the v4l-dvb backports for -stable, and this was
>  > never in my queue, not to mention that it doesn't qualify, based on
>  > the -stable rules.
>
>  I think it does qualify and I've been asking for feedback about this for
>  the past week to everyone on the signed-off-lines above with no real
>  objections :)
>
>  openSUSE had a user that requested this patch be added as they had
>  hardware that needed this patch to work properly on 2.6.25.  As it only
>  added device ids, I didn't see the problem with it.
>
>  Does it cause any problems that you can see?

The patch is fine, and there is nothing wrong with it.

The only problem is that all of the cosmetic cleanups are unnecessary,
and they have caused the patch to appear like a larger change than it
actually is.

I thought it was important for patches going in to -stable to be
"obviously correct".  All of the cleanups remove the "obvious
correctness" from this patch, and introduce the chance of a typo
somewhere.

This is all the result of checkpatch.pl -- now it is run before any
commit occurs to the v4l-dvb mercurial repository, causing people to
merge codingstyle cleanups into actual changesets.  This makes review
more difficult.

I always believe that separate changes should appear in separate
patches.  Had this patch been the simple ID addition & config struct
additions, this discussion would never have occurred.

I withdraw my complaint, but I recommend that the "codingstyle
cleanup" hunks from the patch should be dropped.

Of the 30 deletions, only two of them are valid:

-		.num_device_descs = 1,
+		.num_device_descs = 2,

and

-		.num_device_descs = 6,
+		.num_device_descs = 8,

Regards,

Mike

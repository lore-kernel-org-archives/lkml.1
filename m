Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbYENB1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbYENB1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYENB1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:27:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:56084 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYENB1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HVdyy4VLYLMKYZU5fhFk98gAGyVIb3a0B3Ww3gMb52wbf6UVXGRpKcZphSAUGFPIg47wIA6dzn2GJDp3fhRWnTtYfn3FozzNLbxJAvuHjmtlh95ilFXZ5G7QZ86I+yBzfEikPY9yYqO4cBkLFPJFg9ccVrFsOhC0yGeuP55CIGk=
Message-ID: <37219a840805131827v5faf7710pf0b3f67e570bdc7f@mail.gmail.com>
Date: Tue, 13 May 2008 21:27:30 -0400
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
In-Reply-To: <20080513201120.GB31167@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513200453.064446337@mini.kroah.org>
	 <20080513201053.GA31167@suse.de> <20080513201120.GB31167@suse.de>
X-Google-Sender-Auth: 750aba8d9dada115
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 4:11 PM, Greg KH <gregkh@suse.de> wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us know.
>
>  ------------------
>
>  From: Albert Comerma <albert.comerma@gmail.com>
>
>  patch 6ca8f0b97473dcef3a754bab5239dcfcdd00b244 upstream
>
>  This patch introduces support for dvb-t for the following DiBcom based cards:
>
>  - Terratec Cinergy HT USB XE (USB-ID: 0ccd:0058)
>  - Terratec Cinergy HT Express (USB-ID: 0ccd:0060)
>  - Pinnacle 320CX (USB-ID: 2304:022e)
>  - Pinnacle PCTV72e (USB-ID: 2304:0236)
>  - Pinnacle PCTV73e (USB-ID: 2304:0237)
>  - Yuan EC372S (USB-ID: 1164:1edc)
>
>  Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
>  Signed-off-by: Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>
>  Signed-off-by: Antti Palosaari <crope@iki.fi>
>  Signed-off-by: Albert Comerma <albert.comerma@gmail.com>
>  Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
>  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>  Cc: Michel Morisot <mmorisot.abonnement@belcenter.com>
>  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>  ---
>   drivers/media/dvb/dvb-usb/dib0700_devices.c |  259 ++++++++++++++++++++++++----
>   drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    9
>   2 files changed, 238 insertions(+), 30 deletions(-)


This patch is entirely inappropriate for -stable

Who sent this in?  I usually send in the v4l-dvb backports for
-stable, and this was never in my queue, not to mention that it
doesn't qualify, based on the -stable rules.

Regards,

Mike Krufky

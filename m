Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZFVOCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZFVOCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZFVOB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:01:58 -0400
Received: from dan.rpsys.net ([93.97.175.187]:58777 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZFVOB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:01:58 -0400
Subject: Re: [PATCH] leds: Further document parameters for blink_set()
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090621063936.GA1656@ucw.cz>
References: <1244726268-1517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20090621063936.GA1656@ucw.cz>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 14:51:30 +0100
Message-Id: <1245678690.10200.13.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 08:39 +0200, Pavel Machek wrote:
> On Thu 2009-06-11 14:17:48, Mark Brown wrote:
> > The documentation for the parameters of blink_set() was a bit hard
> > to find so put some where I'd expected to find it.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  include/linux/leds.h |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/leds.h b/include/linux/leds.h
> > index 376fe07..c7f0b14 100644
> > --- a/include/linux/leds.h
> > +++ b/include/linux/leds.h
> > @@ -45,7 +45,9 @@ struct led_classdev {
> >  	/* Get LED brightness level */
> >  	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
> >  
> > -	/* Activate hardware accelerated blink */
> > +	/* Activate hardware accelerated blink, delays are in
> > +	 * miliseconds and if none is provided then a sensible default
> > +	 * should be chosen. */
> >  	int		(*blink_set)(struct led_classdev *led_cdev,
> >  				     unsigned long *delay_on,
> >  				     unsigned long *delay_off);
> 
> What a strange calling convention. Does it return data in
> *delay_on/off ?

It was done so the caller could find out what timings the underlying
hardware decided to chose if it couldn't match the timings specified
exactly. This should be better documented and I'll take care of that.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre


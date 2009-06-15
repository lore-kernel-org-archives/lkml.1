Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbZFOM4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbZFOM4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbZFOM4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:56:39 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61332 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbZFOM4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vImABgAPr9y9ATlVrmW8Aoj0c0TlZlnOtdgXIzUQFCp1YA1iDHZavP7gOJ5HlkvPTi
         JC1bhqeaSeL241qkfQFkz9QFFyb22t5wlL9QNMaZjpMlBL0AhA1XhbUXCV82uv6n+0wm
         A33QEbFP2+sZll3m+XT/ELoFqPbHfV7PNLRuc=
From: Florian Fainelli <florian@openwrt.org>
To: Alek Du <alek.du@intel.com>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
Date: Mon, 15 Jun 2009 14:56:32 +0200
User-Agent: KMail/1.9.9
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615100253.GC6106@sirena.org.uk> <20090615191916.31d95ab7@dxy.sh.intel.com>
In-Reply-To: <20090615191916.31d95ab7@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906151456.33837.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 15 June 2009 13:19:16 Alek Du, vous avez écrit :
> On Mon, 15 Jun 2009 18:02:53 +0800
>
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > On Mon, Jun 15, 2009 at 10:50:23AM +0100, Ben Dooks wrote:
> > > On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:
> > > > * gpio_alt_func is to set pin as alternative function or GPIO.
> > >
> > > gpio_alt_func is feature creep, I don't really belive this is the
> > > best place to put it as it will be difficult to actually make this
> > > generic for all gpio platforms.
> >
> > Since the proposed API just passes a value through to the driver for the
> > GPIO chip it looks generic enough - each chip can define whatever set of
> > constants it likes.  I'd expect a large proportion of driver specific
> > APIs would end up just the same.
> >
> > Given the number of manufacturers that don't use a separate term like
> > the PXA MFP for the alternative functions of their GPIOs it makes sense
> > to have a gpiolib API for this.  Without one you end up having each
> > driver needing to add its own API, and since the pins are just referred
> > to as GPIOs in the documentation the API will have that in the name and
> > look like it ought to be connected with gpiolib.
>
> Mark,
> Thanks for the comments. I do believe that API would benefit some GPIO
> device drivers. I'm preparing a GPIO driver for one Intel IOH that has GPIO
> block needs that API.

This is indeed useful, RB532 in the MIPS tree also has an alternate function 
setting feature.

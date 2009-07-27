Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbZG0PiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbZG0PiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZG0PiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:38:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZG0PiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=rjaKZ1dFLssnp9PT+Vin1vv3cfWirW77Ht0yUM1oi6JDp8D5tQ/QWOSmwxYzNlJkBE
         5rY7iHV6S/fRdJ7fclK8R9A5aIVpf0vHwT3cZw9/7zh5NDwGgmK7V/B80DyMuLjZW6FI
         nwWfPEED6w6DZckktbaeIPzZ+IMFhIWbJEYO4=
Date: Mon, 27 Jul 2009 08:38:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 13/22] Input: Add support for the WM831x ON pin
References: <20090727134527.GA12849@rakim.wolfsonmicro.main> <1248702372-29534-13-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248702372-29534-13-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090727161151.A9D36526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 27, 2009 at 02:46:03PM +0100, Mark Brown wrote:
> --- /dev/null
> +++ b/drivers/input/misc/wm831x-on.c
> @@ -0,0 +1,163 @@
> +/**
> + * wm831x-on.c - WM831X ON pind river
> + *

"Pind river"? ;)

> +
> +static irqreturn_t wm831x_on_irq(int irq, void *data)
> +{
> +	struct wm831x_on *wm831x_on = data;
> +
> +	schedule_work(&wm831x_on->work.work);

schedule_delayed_work(&wm831x_on->work, 0); - I prefer not to expose
delayed work implementation details.

Other than that:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Freel free to push this with the rest of the series. If that does not
work out let me know and I will get this driver into my tree.

Thanks!

-- 
Dmitry

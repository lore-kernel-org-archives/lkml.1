Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZG0PlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZG0PlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZG0PlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:41:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34035 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752676AbZG0PlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:41:08 -0400
Date: Mon, 27 Jul 2009 16:41:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 13/22] Input: Add support for the WM831x ON pin
Message-ID: <20090727154107.GA10526@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
 <1248702372-29534-13-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090727161151.A9D36526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727161151.A9D36526EC9@mailhub.coreip.homeip.net>
X-Cookie: He's dead, Jim.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 08:38:05AM -0700, Dmitry Torokhov wrote:
> On Mon, Jul 27, 2009 at 02:46:03PM +0100, Mark Brown wrote:

> > + * wm831x-on.c - WM831X ON pind river

> "Pind river"? ;)

Err, yes.  Highly innovative new technology!

> > +static irqreturn_t wm831x_on_irq(int irq, void *data)
> > +{
> > +	struct wm831x_on *wm831x_on = data;
> > +
> > +	schedule_work(&wm831x_on->work.work);

> schedule_delayed_work(&wm831x_on->work, 0); - I prefer not to expose
> delayed work implementation details.

> Other than that:

> 	Acked-by: Dmitry Torokhov <dtor@mail.ru>

> Freel free to push this with the rest of the series. If that does not
> work out let me know and I will get this driver into my tree.

OK, I'll fix that when I resend.  Thanks.

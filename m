Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291Ab0ASEuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0ASEuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 23:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248Ab0ASEun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 23:50:43 -0500
Received: from kroah.org ([198.145.64.141]:42080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab0ASEul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 23:50:41 -0500
Date: Mon, 18 Jan 2010 20:49:12 -0800
From: Greg KH <greg@kroah.com>
To: Eirik Aanonsen <EAA@wprmedical.com>
Cc: "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Message-ID: <20100119044912.GB10262@kroah.com>
References: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702> <20100115185457.GG12146@kroah.com> <B5E0EDE940845B429B7ECCE186529F2C0641D181F7@dware2702>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5E0EDE940845B429B7ECCE186529F2C0641D181F7@dware2702>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 08:02:46AM +0100, Eirik Aanonsen wrote:
> > 
> > On Mon, Jan 04, 2010 at 02:01:59PM +0100, Eirik Aanonsen wrote:
> > > Adding vbus_pin_inverted so that the usb detect pin can be active
> > high or low.
> > > This because depending on HW implementation it is better to have
> > active low.
> > > Also replaced the pio_get_value(udc->vbus_pin); with a call to
> > vbus_is_present(udc);
> > >
> > > Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
> > 
> > Please always run your patches through 'scripts/checkpatch.pl' before
> > sending them so that you don't accidentally add coding style errors.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Yes I'm sorry I got that feedback from several others as well.
> 
> That is why I resubmitted the patch on 05.Jan. But under the same name, and since then I have not received any feedback on that patch.
> 
> ***
> Snip from local:
> 
> ./scripts/checkpatch.pl 0014-Adding-vbus_pin_inverted-so-that-the-usb-detect-pin.patch 
> total: 0 errors, 0 warnings, 38 lines checked
> 
> 0014-Adding-vbus_pin_inverted-so-that-the-usb-detect-pin.patch has no obvious style problems and is ready for submission.
> ***

I don't see it in my queue, care to resend?

thanks,

greg k-h

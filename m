Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0AOURd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211Ab0AOUQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:16:49 -0500
Received: from kroah.org ([198.145.64.141]:51575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab0AOUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:16:48 -0500
Date: Fri, 15 Jan 2010 10:54:57 -0800
From: Greg KH <greg@kroah.com>
To: Eirik Aanonsen <EAA@wprmedical.com>
Cc: "kernel@avr32linux.org" <kernel@avr32linux.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Message-ID: <20100115185457.GG12146@kroah.com>
References: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 02:01:59PM +0100, Eirik Aanonsen wrote:
> Adding vbus_pin_inverted so that the usb detect pin can be active high or low.
> This because depending on HW implementation it is better to have active low.
> Also replaced the pio_get_value(udc->vbus_pin); with a call to vbus_is_present(udc);
> 
> Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>

Please always run your patches through 'scripts/checkpatch.pl' before
sending them so that you don't accidentally add coding style errors.

thanks,

greg k-h

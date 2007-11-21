Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXKUPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXKUPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXKUPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:25:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:18974 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbXKUPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t58eSOxY89xi2uiHJq/n5id/i8s+g5icHHhpQMg/WRQz44WV51scVE7cjzYsALbsLpqh/qUWrx050L+WLOLBHLTBIkPsIj0bBgT2QoYcngjjAVyoiE1w8f+hfD4F9CyKSrkNkGpZi1vasd097HFbFXEjQ6mEIXhBTciNhYn2AUo=
Message-ID: <d9def9db0711210725x3fe35fedlc67cf637bc9ad27f@mail.gmail.com>
Date: Wed, 21 Nov 2007 16:25:08 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: USB deadlock after resume
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
In-Reply-To: <200711211615.14829.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
	 <200711211246.39441.oliver@neukum.org>
	 <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
	 <200711211615.14829.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch 21 November 2007 schrieb Markus Rechberger:
> > > Which URB is usb_kill_urb() called for?
> > >
> >
> > it's the usb_control_message which calls usb_kill_urb if I haven't got
> > it wrong. (if you're looking for some other information please let me
> > know)
> > Although, I got a bit further with it. The error seems to happen
> > earlier already.
> > If I load the driver, and do not access the device after suspending
> > all usb_control commands fail with -71 eproto.
>
> A timeout. You should add the RESET_RESUME quirk for your device.
> usb_reset_device() from resume() is not a good idea.
>

ok this is good to know, although I have to stick with kernel 2.6.21.3 here.
It's Laurent's driver best would be to check for the specific
kernelversion and do whatever is appropriate.

thanks,
Markus

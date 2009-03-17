Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbZCQC1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbZCQC1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762512AbZCQC0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:26:54 -0400
Received: from kroah.org ([198.145.64.141]:50574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762377AbZCQC0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:26:52 -0400
Date: Mon, 16 Mar 2009 19:25:31 -0700
From: Greg KH <greg@kroah.com>
To: Peta Blaha <blahapeta@gmail.com>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input/joystick: add driver fortius 1942
Message-ID: <20090317022531.GA504@kroah.com>
References: <739e73230903161921u426f2c65gddbc089d25ba5d50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <739e73230903161921u426f2c65gddbc089d25ba5d50@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 03:21:18AM +0100, Peta Blaha wrote:
> Driver for Fortius 1942 device.
> 
> Signed-off-by: Petr Blaha <blahapeta@gmail.com>
> ---
> 
> --- a/drivers/input/joystick/fortius_1942.c.orig 1970-01-01
> 01:00:00.000000000 +0100

Your patch is linewrapped :(

> +++ b/drivers/input/joystick/fortius_1942.c 2009-03-17 03:17:01.000000000 +0100
> @@ -0,0 +1,394 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

Are you sure about "any later version"?
> + unsigned long difference = 0;
> + /*time measure*/
> + struct timeval time, time_before;
> + /*guessed fastest speed a man can possibly ride-incitating full
> + throttle*/
> + unsigned int fastest_wheel_rotate = 1000;
> + /*actual state of path reached in one cycle*/
> + unsigned int ride = 0, old_ride = 0;

These should all be static.

Have you run your code through scripts/checkpatch.pl?

> +struct usb_tfor {
> + char name[128];

Tabs are eaten by your email client :(

Care to try again?

thanks,

greg k-h

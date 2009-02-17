Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZBQDY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZBQDY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBQDXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:23:54 -0500
Received: from kroah.org ([198.145.64.141]:35479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752141AbZBQDXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:23:50 -0500
Date: Mon, 16 Feb 2009 19:18:13 -0800
From: Greg KH <greg@kroah.com>
To: Mike Murphy <mamurph@cs.clemson.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: xpad.c - Xbox 360 wireless and sysfs support
Message-ID: <20090217031813.GD8343@kroah.com>
References: <5aa163d00902142008g138826br80d3ea989e7af691@mail.gmail.com> <200902160931.34771.oliver@neukum.org> <5aa163d00902160522r3a22412je3f5202076f57a0a@mail.gmail.com> <20090216161331.GB5008@kroah.com> <5aa163d00902161009l15dae120le96436d40f998d33@mail.gmail.com> <20090216185914.GA6239@kroah.com> <5aa163d00902161130r2030adb8h6eb1ec08bda92744@mail.gmail.com> <20090216202215.GA6543@kroah.com> <5aa163d00902161853x27d98a83l3c2c02abe651fe1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aa163d00902161853x27d98a83l3c2c02abe651fe1e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 09:53:54PM -0500, Mike Murphy wrote:
> struct usb_xpad {
> 	struct input_dev *dev;		/* input device interface */
> 	struct usb_device *udev;	/* usb device */
> ...
> };
> 
> This is not my code... it was set up this way in the stable xpad driver.

And it is correct :)

> So it looks like I'm stuck with a struct input_dev * pointer to the
> input device, a struct device * pointer in the show/store handlers,
> and no way to get back to struct usb_xpad * with the container_of
> macro. Unless, of course, there is something I don't know about
> container_of (or another macro I can use in this instance).

input_set_drvdata() and input_get_drvdata() is what you are looking for.

Hope this helps,

greg k-h

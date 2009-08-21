Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbZHUXi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbZHUXi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZHUXi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:38:28 -0400
Received: from kroah.org ([198.145.64.141]:41830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650AbZHUXi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:38:27 -0400
Date: Fri, 21 Aug 2009 16:33:38 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Soeren Sonnenburg <bugreports@nn7.de>,
       =?iso-8859-1?Q?J=E9r=E9mie?= Huchet <jeremie@lamah.info>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Samsung laptop driver
Message-ID: <20090821233338.GA28241@kroah.com>
References: <20090821225925.GA27625@kroah.com>
 <20090821161952.1b84480c@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821161952.1b84480c@jbarnes-g45>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 04:19:52PM -0700, Jesse Barnes wrote:
> On Fri, 21 Aug 2009 15:59:25 -0700
> Greg KH <greg@kroah.com> wrote:
> > Jesse, I don't know how this is going to play with your recently added
> > backlight support for the i915 driver.  As you don't have control over
> > the LEDs and other stuff that this driver is going to support, I think
> > we need some way to keep the i915 driver from messing with the
> > backlight values, don't you think?
> 
> Right, it should be fine.  The i915 driver should only take control and
> provide a backlight when:
>   - no ACPI method is available
>   - no platform method is available (like this one)
>   - backlight is exposed through the GPU or i2c
> 
> So I'm a lot happier now that you've figured out the proper platform
> interface. :)  The test code I sent out earlier didn't work for Mike
> because his VBIOS (properly it turns out) indicated that there was an
> external agent in charge of the backlight.

Great, then all should be good, thanks for letting me know.

Now I wonder if Mike's laptop can be controlled through my new driver,
that would be an interesting test.  I'll ping him about it.

thanks,

greg k-h

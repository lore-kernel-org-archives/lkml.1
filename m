Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885Ab0AHROP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0AHROP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764Ab0AHROO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:14:14 -0500
Received: from kroah.org ([198.145.64.141]:54509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0AHROM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:14:12 -0500
Date: Fri, 8 Jan 2010 09:13:29 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
Message-ID: <20100108171329.GA4711@kroah.com>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
 <20100108083020.GB3696@core.coreip.homeip.net>
 <20100108163655.GA8328@elf.ucw.cz>
 <a3581fd32d39b5e86aba9ded88bd5f46.squirrel@intranet.cs.nmsu.edu>
 <20100108170450.GB8328@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108170450.GB8328@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 06:04:50PM +0100, Pavel Machek wrote:
> On Fri 2010-01-08 09:50:33, Rick L. Vinyard, Jr. wrote:
> > Pavel Machek wrote:
> > > Hi!
> > >
> > >> > +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
> > >>
> > >> What this attribute is for?
> > >
> > > Actually, all the new files this added need to be documented.
> > 
> > Which is better? A hid-g13.txt file added to Documentation/ or comments in
> > the driver itself?
> 
> Documentation. Coordinate with sysfs maintainer (gregkh).

All sysfs files need to be documented in Documentation/ABI/  Please add
the documentation there for your new sysfs files.

thanks,

greg k-h

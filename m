Return-Path: <linux-kernel-owner+w=401wt.eu-S935637AbXFHOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637AbXFHOs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbXFHOss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:48:48 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:47964 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbXFHOss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:48:48 -0400
Date: Fri, 8 Jun 2007 16:48:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, i2c@lm-sensors.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [i2c] i2c module aliases
In-Reply-To: <20070608153516.28fd9eb5@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0706081647310.9505@anakin>
References: <Pine.LNX.4.64.0706062325270.30244@anakin>
 <20070607175342.3006e872@hyperion.delvare> <20070607160214.GB17800@kroah.com>
 <20070608153516.28fd9eb5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Jean Delvare wrote:
> On Thu, 7 Jun 2007 09:02:14 -0700, Greg KH wrote:
> > On Thu, Jun 07, 2007 at 05:53:42PM +0200, Jean Delvare wrote:
> > > Looks correct. However I am curious what this "i2c->id" is supposed to
> > > represent, given that I2C devices do not have any form of ID as PCI or
> > > USB devices have. No driver uses "MODULE_DEVICE_TABLE(i2c, ...)"
> > > probably just because it doesn't make sense. So, rather than fixing
> > > this, shouldn't we simply wipe out struct i2c_device_id? Greg, David?
> > 
> > If no one is using it, then yes, it should be removed.
> > 
> > Sorry, I added it a while ago thinking it was going to be used (I had
> > test patches using it in my tree, but they never worked out in the end.)
> 
> OK. Geert, care to submit a new patch removing struct i2c_device_id
> altogether?

Sorry, probably not...

I just thought I found a grave bug while looking into adding zorro
support to scripts/mod/file2alias.c, so that's why I reported it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

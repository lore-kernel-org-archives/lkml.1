Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZHZQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZHZQj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZHZQj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:39:57 -0400
Received: from kroah.org ([198.145.64.141]:46882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbZHZQjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:39:55 -0400
Date: Wed, 26 Aug 2009 09:32:22 -0700
From: Greg KH <greg@kroah.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Soeren Sonnenburg <bugreports@nn7.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       =?iso-8859-1?Q?J=E9r=E9mie?= Huchet <jeremie@lamah.info>
Subject: Re: [Intel-gfx] [PATCH] Samsung laptop driver
Message-ID: <20090826163222.GD22474@kroah.com>
References: <20090821225925.GA27625@kroah.com>
 <20090822120701.78dc10d5@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090822120701.78dc10d5@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 22, 2009 at 12:07:01PM +0200, Bruno Prémont wrote:
> On Fri, 21 August 2009 Greg KH <greg@kroah.com> wrote:
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > Subject: Samsung laptop driver
> > 
> > This driver implements backlight controls for Samsung laptops that
> > currently do not have ACPI support for this control.
> > 
> > It has been tested on the N130 laptop and properly works there.
> > 
> > Many thanks to Dmitry Torokhov <dmitry.torokhov@gmail.com> for
> > cleanups and other suggestions on how to make the driver simpler.
> 
> Hm, that one fails to compile here:
>   CC [M]  drivers/platform/x86/samsung-laptop.o
> /usr/src/linux-2.6/drivers/platform/x86/samsung-laptop.c: In function 'sabi_get_command':
> /usr/src/linux-2.6/drivers/platform/x86/samsung-laptop.c:141: error: implicit declaration of function 'msleep'
> make[5]: *** [drivers/platform/x86/samsung-laptop.o] Error 1
> make[4]: *** [drivers/platform/x86] Error 2
> make[3]: *** [drivers/platform] Error 2
> make[2]: *** [drivers] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> Missing a #include <linux/delay.h>?

Yes, I've added it now, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0BRAQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:16:22 -0500
Received: from kroah.org ([198.145.64.141]:49907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab0BRAQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:16:18 -0500
Date: Wed, 17 Feb 2010 15:40:02 -0800
From: Greg KH <greg@kroah.com>
To: roel kluin <roel.kluin@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if
 usb_control_msg() fails in usb_reset_configuration()
Message-ID: <20100217234002.GE12197@kroah.com>
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org>
 <4B7186F1.808@gmail.com>
 <20100209220120.GB4607@xanatos>
 <25e057c01002091409l83a7d7fwd2f7762725f83e50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25e057c01002091409l83a7d7fwd2f7762725f83e50@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 11:09:45PM +0100, roel kluin wrote:
> On Tue, Feb 9, 2010 at 11:01 PM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > On Tue, Feb 09, 2010 at 05:01:53PM +0100, Roel Kluin wrote:
> >> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
> >> break occurred, i equals config->desc.bNumInterfaces. so if
> >> usb_control_msg() failed then after goto reset_old_alts we read from
> >> config->interface[config->desc.bNumInterfaces].
> >> We can safely decrement i as well if the break occurred.
> >>
> >> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> >
> > Bah, yes, you're right. :)  Good catch.
> 
> Could you please confirm whether this patch is the better or the
> other (in this same thread)?

Can someone tell me which one is the correct one to apply, but resending
it to me?

thanks,

greg k-h

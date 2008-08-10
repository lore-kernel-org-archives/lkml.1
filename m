Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYHJDim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYHJDim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 23:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYHJDiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 23:38:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:53039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbYHJDiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 23:38:24 -0400
Date: Sat, 9 Aug 2008 20:36:32 -0700
From: Greg KH <greg@kroah.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [01/03] USB: add CONFIG_USB_DEBUG_MESSAGES and usb_dbg()
Message-ID: <20080810033631.GB30733@kroah.com>
References: <20080809013820.GA10910@kroah.com> <20080809013917.GB10910@kroah.com> <20080809150439.GA5408@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809150439.GA5408@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 05:04:43PM +0200, Marcin Slusarz wrote:
> On Fri, Aug 08, 2008 at 06:39:17PM -0700, Greg KH wrote:
> > --- a/drivers/usb/core/usb.h
> > +++ b/drivers/usb/core/usb.h
> > @@ -132,6 +132,28 @@ static inline int is_active(const struct
> >  /* for labeling diagnostics */
> >  extern const char *usbcore_name;
> >  
> > +/* USB debugging */
> > +/* if debug is on or not for the USB core */
> > +extern int usb_debug;
> > +
> > +#if defined(CONFIG_USB_DEBUG_MESSAGES)
> > +/* macro for debugging */
> > +#define usb_dbg(dev, format, arg...)					\
> > +	({								\
> > +		if (usb_debug)						\
> 
> maybe unlikely here?

Does it really generate better code?

I really dislike using unlikely except for fast paths.

thanks,

greg k-h

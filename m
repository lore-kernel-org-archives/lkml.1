Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZJJPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZJJPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZJJPJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:09:58 -0400
Received: from kroah.org ([198.145.64.141]:35642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbZJJPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:09:57 -0400
Date: Sat, 10 Oct 2009 08:05:23 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Josua Dietze <digidietze@draisberghof.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
Message-ID: <20091010150523.GA28957@kroah.com>
References: <1255134315.2139.8.camel@pasglop> <4AD03A03.5050702@draisberghof.de> <1255160461.3387.4.camel@pasglop> <200910101155.48394.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910101155.48394.oliver@neukum.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 11:55:47AM +0200, Oliver Neukum wrote:
> Am Samstag, 10. Oktober 2009 09:41:01 schrieb Benjamin Herrenschmidt:
> > suspend is a good candidate yeah, autosuspend might be causing something
> > like that, I'll see what I can find. I didn't spot an obvious change to
> > the USB suspend policy between those two kernels, but it could be
> > trigged by one of the numerous changes that went into usb-serial.
> 
> Then you can simply test this hunch by switching it off. If that helps
> please recompile with CONFIG_USB_DEBUG enabled?
> 
> But I don't understand why the stable series is affected. Autosuspend
> patches didn't go into it, did they Greg?

Not that I can see, no.

thanks,

greg k-h

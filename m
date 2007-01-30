Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXA3Ubk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXA3Ubk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXA3Ubk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:31:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:56519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXA3Ubk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:31:40 -0500
Date: Tue, 30 Jan 2007 12:30:39 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Lyon <andrew.lyon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130203039.GA23370@kroah.com>
References: <20070130012904.GA9617@kroah.com> <f4527be0701301215q11924e3fnaaa5f33e6b6c5b36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4527be0701301215q11924e3fnaaa5f33e6b6c5b36@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 08:15:11PM +0000, Andrew Lyon wrote:
> 
> How about a kernel driver for the m-cubed tbalancer bigNG ?
> 
> http://www.t-balancer.com/english/bng.htm  (see support section of site)
> 
> Complete documentation is available, and devs are friendly (see
> forums), there is already a userspace utility that works well but a
> kernel driver would be even better, especially for something that
> controls system cooling!

Why would a userspace driver not work out for this.  We already can
saturate the USB bus with a userspace program, and since it requires a
userspace interaction to do something with the data, I don't really see
what a kernel driver could do to help thing out.

That being said, perhaps it would fit with the other USB data
acquisition drivers that we already have.  Feel free to take this up
with me off-list if you want to.

Hm, wait, in looking at the specs for the device, it uses a
usb-to-serial chip that we already support quite well (with the
pl2303.ko driver.)  So all you need to do is write some userspace
software that interacts with the device properly.  No new kernel driver
is needed at all, as Linux already supports this hardware :)

thanks,

greg k-h

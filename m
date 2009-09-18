Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZIRGQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZIRGQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZIRGQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:16:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZIRGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:16:01 -0400
Date: Thu, 17 Sep 2009 23:15:29 -0700
From: Greg KH <greg@kroah.com>
To: Bart Hartgers <bart.hartgers@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ondrej Zary <linux@rainbow-software.org>, ark3116_driver@auctionant.de
Subject: Re: New ark3116 driver - how to get included into kernel?
Message-ID: <20090918061529.GB7717@kroah.com>
References: <7eb6a4d80909170549k7a19eb01s8975fe2c5f230cee@mail.gmail.com> <7eb6a4d80909170552na322914x23b65d60bb56e20d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7eb6a4d80909170552na322914x23b65d60bb56e20d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:52:29PM +0200, Bart Hartgers wrote:
> (Sorry for sending an HTML-ized version of this mail before)
> 
> Hi All,
> 
> I managed to write an improved ark3116 driver after I figured out that
> it is just an 16450 UART with some USB glue logic.
> 
> The attached files can be compiled outside the kernel tree, and work
> for 2.6.31. However, I would like this driver to (eventually) end up
> in the kernel tree. In order to get there, who should I sent patches
> against what? I've contributed code to the kernel before, but not in
> the last 5 or so years, so I am a bit out of touch.

Take a look at the file, Documentation/SubmittingPatches, it should
describe what you need to do.

> Compared to the old ark3116 driver this one offers the following improvements:
>  - cts/rts handshake support
>  - break signalling
>  - line error detection

Why can't you just send patches adding support for these features to the
existing driver?  It shouldn't be that much different between the two
versions, right?

That's the preferred method, I'd like to not drop the existing one if at
all possible.

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZDOFTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZDOFTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZDOFTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:19:08 -0400
Received: from kroah.org ([198.145.64.141]:48732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752205AbZDOFTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:19:06 -0400
Date: Tue, 14 Apr 2009 22:09:47 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415050947.GB3462@kroah.com>
References: <49E4FAC6.1030400@garzik.org> <20090415014930.GA29413@kroah.com> <49E5480F.10501@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5480F.10501@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:35:59PM -0400, Jeff Garzik wrote:
> > Like Arjan said, this is because we are initializing faster now, and
> > things are a bit more asynchronous.  Use the root_delay boot option,
> > that's what I use for my USB-based systems, and have not had a problem
> > with that at all.
> 
> Is that solution really scalable to every user with a regression severe 
> enough it prevents them from booting?
> 
> When did regressions become an acceptable tradeoff for speed?

So, we aren't allowed to go faster?

What happens when you buy a new box with more USB host controllers and a
faster processor?  Same problem.

> This system boots just fine under kernel 2.6.27, 2.6.26, 2.6.25, and so 
> on.  Switch the kernel to 2.6.28, and it no longer boots.  A regression 
> cannot get more clear than that.
> 
> Maybe this commit should have been accompanied by one that checks "root=" ?

How would that be accomplished?

The issue is that you were just lucky that your machine worked properly
previously.  My boxes with the same type of setup didn't, so I quickly
realized what the root delay boot option was for.  You need to just do
the same thing here, there's nothing else we can do.

thanks,

greg k-h

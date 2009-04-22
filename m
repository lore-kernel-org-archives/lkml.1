Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZDVVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZDVVDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZDVVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:03:21 -0400
Received: from kroah.org ([198.145.64.141]:36009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752577AbZDVVDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:03:19 -0400
Date: Wed, 22 Apr 2009 13:29:20 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Message-ID: <20090422202920.GA20231@kroah.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com> <20090422055327.GF9009@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com> <20090422174212.GA18564@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165F065@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090165F065@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 04:18:59PM -0400, H Hartley Sweeten wrote:
> Fix sparse warnings in drivers/usb/host/ohci-hcd.c.
> 
> Four of the following sparse warning are seen when building on
> ARM due do the macro raw_local_irq_save():
> 
> 	warning: symbol 'temp' shadows an earlier one
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> Patch is also attached in case of line-wrapping.

It was line-wrapped, but as your attachment was in base64 mode, it was
easier to hand edit the patch to fix the line-wrapping.

So, I think you still need to work a bit on your email client issues :)

thanks,

greg k-h

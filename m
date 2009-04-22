Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZDVT0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZDVT0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZDVT0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:26:21 -0400
Received: from kroah.org ([198.145.64.141]:42663 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752577AbZDVT0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:26:21 -0400
Date: Wed, 22 Apr 2009 12:23:16 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Message-ID: <20090422192316.GA19411@kroah.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com> <20090422055327.GF9009@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com> <20090422174212.GA18564@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165EFC9@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090165EFC9@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:50:56PM -0400, H Hartley Sweeten wrote:
> On Wednesday, April 22, 2009 10:42 AM, Greg KH wrote:
> > On Wed, Apr 22, 2009 at 01:39:34PM -0400, H Hartley Sweeten wrote:
> >> On Tuesday, April 21, 2009 10:53 PM, Greg KH wrote:
> >>> On Wed, Apr 15, 2009 at 10:04:17PM -0400, H Hartley Sweeten wrote:
> >>> Fix sparse warnings in drivers/usb/host/ohci-hcd.c.
> >>>> 
> >>>> 	warning: symbol 'temp' shadows an earlier one
> >>>> 
> >>>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >>>
> >>> I'm not seeing this sparse warning either.
> >>>
> >>> And you didn't fix the two sparse warnings I am seeing in this file,
> >>> so I'm going to think this patch doesn't really do anything :(
> >> 
> >> Following are the sparse warnings I am seeing when building for an
> >> EP93xx ARM platform:
> >
> > Ah, on ARM, sorry, I was building on x86.
> >
> > Care to respin this one, and your other one without the whitespace
> > changes and line-wraps and resend them?
> 
> Not a problem. I will have to attach the patches to avoid the
> line-warps.
> It appears that the wrapping is occurring when my emails be bounced thru
> one of my ISP's servers. I'm still trying to resolve that.
> 
> Question: How do you do a git diff and keep the whitespace changes out?

Don't do the whitespace changes in the first place :)

thanks,

greg k-h

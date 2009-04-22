Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZDVRqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZDVRqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZDVRqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:46:11 -0400
Received: from kroah.org ([198.145.64.141]:45303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbZDVRqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:46:09 -0400
Date: Wed, 22 Apr 2009 10:42:12 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Message-ID: <20090422174212.GA18564@kroah.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com> <20090422055327.GF9009@kroah.com> <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:39:34PM -0400, H Hartley Sweeten wrote:
> On Tuesday, April 21, 2009 10:53 PM, Greg KH wrote:
> > On Wed, Apr 15, 2009 at 10:04:17PM -0400, H Hartley Sweeten wrote:
> > Fix sparse warnings in drivers/usb/host/ohci-hcd.c.
> >> 
> >> 	warning: symbol 'temp' shadows an earlier one
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >
> > I'm not seeing this sparse warning either.
> >
> > And you didn't fix the two sparse warnings I am seeing in this file,
> > so I'm going to think this patch doesn't really do anything :(
> 
> Following are the sparse warnings I am seeing when building for an
> EP93xx ARM platform:

Ah, on ARM, sorry, I was building on x86.

Care to respin this one, and your other one without the whitespace
changes and line-wraps and resend them?

thanks,

greg k-h

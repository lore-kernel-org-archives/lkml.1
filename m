Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbZGNEEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbZGNEEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZGNEEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:04:23 -0400
Received: from kroah.org ([198.145.64.141]:45623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZGNEEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:04:23 -0400
Date: Mon, 13 Jul 2009 21:03:46 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: usb series import failure
Message-ID: <20090714040346.GA10393@kroah.com>
References: <20090714112648.d2157b44.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714112648.d2157b44.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 11:26:48AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next import of the usb quilt series failed like this:
> 
> usb-make-the-usbfs_snoop-log-more-pertinent.patch
> error: patch failed: drivers/usb/core/devio.c:347
> error: drivers/usb/core/devio.c: patch does not apply
> 
> I commented out the above patch which lead to:
> 
> usb-gadget-pxa25x-basic-transceiver-support.patch
> error: patch failed: drivers/usb/gadget/pxa25x_udc.c:2162
> error: drivers/usb/gadget/pxa25x_udc.c: patch does not apply
> 
> And on ...
> 
> It looks like the some of the usb patches haven't been updated for the
> rebase onto -git9.  I have dropped the usb and staging trees for today.

Sorry, it's now rebased properly and pushed out.

thanks,

greg k-h

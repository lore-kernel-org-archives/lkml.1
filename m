Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbXJXWAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbXJXWAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXJXV75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:59:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39100 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXJXV74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:59:56 -0400
Date: Wed, 24 Oct 2007 14:27:39 -0700
From: Greg KH <greg@kroah.com>
To: Richard Pearman <richard.pearman@intellect.com.au>
Cc: pberger@brimson.com, borchers@steinerpoint.com, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001] USB: Error handling bug fix for serial_open()
Message-ID: <20071024212739.GB4638@kroah.com>
References: <4709B59F.3020307@intellect.com.au> <20071008220821.GA31234@kroah.com> <471C1D3C.1080801@intellect.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471C1D3C.1080801@intellect.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 11:47:08AM +0800, Richard Pearman wrote:
> From: Richard Pearman <richard.pearman@intellect.com.au>
> From: Greg Breen <greg.breen@intellect.com.au>
>
> When an error occurs in serial_open() ensure that port->tty and 
> tty->driver_data are set  to NULL, if previously assigned a value in the 
> function.
>
> Signed-off-by: Richard S. Pearman <richard.pearman@intellect.com.au>
> ---
> --- linux-2.6.17.1/drivers/usb/serial/usb-serial.c.orig    Mon Oct 22 

This has already been fixed in newer kernel versions.

Thanks for the patch though.

greg k-h

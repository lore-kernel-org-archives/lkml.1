Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYDRDSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYDRDSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYDRDR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:17:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYDRDRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:17:55 -0400
Date: Thu, 17 Apr 2008 20:24:05 -0700
From: Greg KH <greg@kroah.com>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: smurf@smurf.noris.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial: option: Don't match Huawei driver CD images
Message-ID: <20080418032405.GB8754@kroah.com>
References: <1208472569.14194.5.camel@hermes2.karcher.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208472569.14194.5.camel@hermes2.karcher.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 12:49:29AM +0200, Michael Karcher wrote:
> From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> 
> Add the interface info matching to all Huawei cards, as they all also
> contain a Mass Storage Device interface (usually containing Windows
> drivers) which should not get bound by this driver.
> 
> See also drivers/usb/storage/unusual_devs.h
> 
> Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> 
> ---
> 
> Formatting as one-liners is done like in HUAWEI_PRODUCT_E220 entries
> that were already present. This breaks the 80 chars/line recommendation,
> feel free to reformat (or tell me to submit a reformatted patch).
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c

What is this patch against?  We have a change that went into 2.6.25
after 2.6.25-rc9 that should make this patch not be needed.

Can you try that release and verify this?

thanks,

greg k-h

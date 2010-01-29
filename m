Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217Ab0A2WFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0A2WFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119Ab0A2WFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:05:51 -0500
Received: from kroah.org ([198.145.64.141]:55265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab0A2WFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:05:51 -0500
Date: Fri, 29 Jan 2010 14:06:01 -0800
From: Greg KH <greg@kroah.com>
To: Derek Atkins <warlord@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
Message-ID: <20100129220601.GA19687@kroah.com>
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 09:15:09AM -0500, Derek Atkins wrote:
> 
> Approved By:  Derek Atkins <warlord@MIT.EDU>

What does that mean?

> --- drivers/base/core.c~	2009-03-23 19:12:14.000000000 -0400
> +++ drivers/base/core.c	2009-10-16 12:15:57.000000000 -0400

Wrong diff level.

> @@ -1200,7 +1200,7 @@
>  EXPORT_SYMBOL_GPL(device_del);
>  EXPORT_SYMBOL_GPL(device_unregister);
>  EXPORT_SYMBOL_GPL(get_device);
> -EXPORT_SYMBOL_GPL(put_device);
> +EXPORT_SYMBOL(put_device);

No, sorry, I've already successfully taken legal action against
companies who have tried to go around the driver core's GPL-only
symbols, so I can not, and will not, make this change.

thanks,

greg k-h

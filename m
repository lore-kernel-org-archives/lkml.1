Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYKQXsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYKQXsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKQXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:48:16 -0500
Received: from kroah.org ([198.145.64.141]:50795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751823AbYKQXsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:48:15 -0500
Date: Mon, 17 Nov 2008 14:53:59 -0800
From: Greg KH <greg@kroah.com>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: chris: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081117225359.GB10377@kroah.com>
References: <1226018320.3189.9.camel@nga> <20081107120136.GD4013@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107120136.GD4013@axis.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:01:36PM +0100, Jesper Nilsson wrote:
> On Fri, Nov 07, 2008 at 01:38:40AM +0100, Kay Sievers wrote:
> > This patch is part of a larger patch series which will remove
> > the "char bus_id[20]" name string from struct device. The device
> > name is managed in the kobject anyway, and without any size
> > limitation, and just needlessly copied into "struct device".
> 
> Thanks, but I think that since this driver has been broken a long time
> it is high time to fix it, and I think the fix removes the need for your patch.
> 
> Greg, could you please look this patch over?
> 
> 
> [CRISv32] Fix IOP fw-loader to use platform_device.
> 
> Change IOP fw-loader to use platform_device instead of
> raw device, which should be more correct usage.
> 
> Signed-off-by: Stefan Andersson <stefan.andersson@axis.com>
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

Looks sane to me.  Want me to take it through my tree, or will you be
submitting it?

thanks,

greg k-h

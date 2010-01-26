Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551Ab0AZE1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0AZE1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519Ab0AZE1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:27:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab0AZE12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:27:28 -0500
Date: Mon, 25 Jan 2010 20:21:37 -0800
From: Greg KH <gregkh@suse.de>
To: d binderman <dcb314@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RE: Linux kernel 2.6.33-rc5 bug report
Message-ID: <20100126042137.GA31666@suse.de>
References: <20100125060850.GA23232@suse.de> <BLU108-W259018EFE8CC5014C4C1829C5F0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU108-W259018EFE8CC5014C4C1829C5F0@phx.gbl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:16:55AM +0000, d binderman wrote:
> 
> 
> Hello there,
> 
> Greg wrote:
> > Care to make up a patch to fix this issue? 
> 
> Here is an untested trivial patch to fix a memory leak in Linux kernel
> 2.6.33-rc5 directory drivers/staging/otus
> 
> From:  David Binderman <dcb314@hotmail.com>
> 
> Fix memory leak in drivers/staging/otus
> 
> Signed-off-by: David Binderman <dcb314@hotmail.com>
> 
> ---
> 
> 
> --- drivers/staging/otus/ioctl.c.sav??? 2010-01-25 09:45:30.000000000 +0000
> +++ drivers/staging/otus/ioctl.c??????? 2010-01-25 09:55:56.000000000 +0000
> @@ -866,15 +866,15 @@ int usbdrvwext_giwscan(struct net_device
> ??????? char *current_ev = extra;
> ??????? char *end_buf;
> ??????? int i;
> -?????? /* struct zsBssList BssList; */
> -?????? struct zsBssListV1 *pBssList = kmalloc(sizeof(struct zsBssListV1),
> -?????????????????????????????????????????????????????????????? GFP_KERNEL);
> ??????? /* BssList = wd->sta.pBssList; */

Very wierd characters here, can you attach the patch instead?

thanks,

greg k-h

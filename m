Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0CFRHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:07:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0CFRHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:07:11 -0500
Date: Sat, 6 Mar 2010 08:57:36 -0800
From: Greg KH <gregkh@suse.de>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix race condition in drivers/base/dd.c
Message-ID: <20100306165736.GA24154@suse.de>
References: <1267894214.18869.1.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267894214.18869.1.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 05:50:14PM +0100, Stefani Seibold wrote:
> This patch fix a potential race condition in the driver_bound() function
> in the file driver/base/dd.c. 
> 
> The broadcast of the BUS_NOTIFY_BOUND_DRIVER notifier should be done
> after adding the new device to the driver list. Otherwise notifier
> listener will fail if they use functions like usb_find_interface().
> 
> The patch is against kernel 2.6.33. Please merge it.

Looks good, are there bugs caused by this problem today that require
this patch to be backported to the -stable kernels?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0CFRPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:15:23 -0500
Received: from www84.your-server.de ([213.133.104.84]:47622 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0CFRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:15:21 -0500
Subject: Re: [PATCH] fix race condition in drivers/base/dd.c
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100306165736.GA24154@suse.de>
References: <1267894214.18869.1.camel@wall-e>
	 <20100306165736.GA24154@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 06 Mar 2010 18:15:41 +0100
Message-ID: <1267895741.19406.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 06.03.2010, 08:57 -0800 schrieb Greg KH:
> On Sat, Mar 06, 2010 at 05:50:14PM +0100, Stefani Seibold wrote:
> > This patch fix a potential race condition in the driver_bound() function
> > in the file driver/base/dd.c. 
> > 
> > The broadcast of the BUS_NOTIFY_BOUND_DRIVER notifier should be done
> > after adding the new device to the driver list. Otherwise notifier
> > listener will fail if they use functions like usb_find_interface().
> > 
> > The patch is against kernel 2.6.33. Please merge it.
> 
> Looks good, are there bugs caused by this problem today that require
> this patch to be backported to the -stable kernels?
> 

No, there is no problem in the stable kernel. There was only a problem
with one of my out of tree driver.

Stefani



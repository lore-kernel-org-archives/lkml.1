Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbXB1Qlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbXB1Qlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXB1Qlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:41:31 -0500
Received: from suite3.10tohost.com ([69.90.40.118]:42701 "EHLO
	suite3.10tohost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXB1Qla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:41:30 -0500
X-Greylist: delayed 3059 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 11:41:30 EST
Date: Wed, 28 Feb 2007 07:36:17 -0800
From: Greg KH <gregkh@suse.de>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
Message-ID: <20070228153617.GA5670@suse.de>
References: <20070228012741.GA3988@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228012741.GA3988@bougret.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 05:27:41PM -0800, Jean Tourrilhes wrote:
> diff -u -p linux/drivers/base/class.j1.c linux/drivers/base/class.c
> --- linux/drivers/base/class.j1.c	2007-02-26 18:38:10.000000000 -0800
> +++ linux/drivers/base/class.c	2007-02-27 15:52:37.000000000 -0800
> @@ -841,6 +841,8 @@ int class_device_rename(struct class_dev

This function is not in the 2.6.21-rc2 kernel, so you might want to
rework this patch a bit :)

Also, it's userspace that causes the rename to happen, so it knows it
did it, why should the kernel have to emit a message to tell userspace
again what just happened?

thanks,

greg k-h

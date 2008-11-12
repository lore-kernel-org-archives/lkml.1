Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYKLUbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYKLUbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYKLUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:31:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60168 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYKLUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:31:09 -0500
Date: Wed, 12 Nov 2008 15:19:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Jolliffe <bobjolliffe@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8187 : support for Sitecom WL-168 0001 v4
Message-ID: <20081112201949.GG2411@tuxdriver.com>
References: <a1820cc70811121216o45435bdfs221415c9c960d276@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1820cc70811121216o45435bdfs221415c9c960d276@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 08:16:59PM +0000, Bob Jolliffe wrote:
> Hi,
> the Sitecom 0001 v4 with product id 0x0df6:0028, uses Realtek's
> RTL8187B and work fine
> with new 2.6.27 driver. Please consider to add support of this card.
> 
> *** linux-2.6.27/drivers/net/wireless/rtl8187_dev.c	2008-10-09
> 23:13:53.000000000 +0100
> --- linux-source-2.6.27/drivers/net/wireless/rtl8187_dev.c	2008-11-12
> 14:39:18.000000000 +0000
> ***************
> *** 45,50 ****
> --- 45,51 ----
>   	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
>   	/* Sitecom */
>   	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
> + 	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
>   	{}
>   };

Thanks for the patch!  In the future, you may want to copy
linux-wireless@vger.kernel.org as well (or instead).

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

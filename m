Return-Path: <linux-kernel-owner+w=401wt.eu-S1762619AbZLPRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762619AbZLPRcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762589AbZLPRcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:32:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762585AbZLPRcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:32:04 -0500
Subject: Re: [PATCH] ep93xx_eth.c: general cleanup
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Nick M." <nickm@visionengravers.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200ECDE@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200ECDE@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 09:32:01 -0800
Message-ID: <1260984721.30093.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 12:09 -0500, H Hartley Sweeten wrote:
> +#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__

I think KBUILD_MODNAME ":%s: " fmt, __func__
or its equivalent direct use is more common.
It's possibly useful to standardize.

> -#define DRV_MODULE_NAME		"ep93xx-eth"
> -#define DRV_MODULE_VERSION	"0.1"
> +#include <mach/hardware.h>

I think these sorts of defines are common and useful.

>  static int __init ep93xx_eth_init_module(void)
>  {
> -	printk(KERN_INFO DRV_MODULE_NAME " version " DRV_MODULE_VERSION " loading\n");

Why remove this printk completely?



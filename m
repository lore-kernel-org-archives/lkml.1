Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbYHRJkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbYHRJkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYHRJkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:40:07 -0400
Received: from sacred.ru ([62.205.161.221]:44719 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYHRJkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:40:06 -0400
Message-ID: <48A94061.8040206@openvz.org>
Date: Mon, 18 Aug 2008 13:26:57 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>
CC: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Devel] [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
References: <20080807224033.FFB3A2C1@kernel> <20080807224034.735B1F84@kernel>
In-Reply-To: <20080807224034.735B1F84@kernel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 18 Aug 2008 13:26:58 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -puN /dev/null ckpt/ckpt_hdr.h
> --- /dev/null	2007-04-11 11:48:27.000000000 -0700
> +++ linux-2.6.git-dave/ckpt/ckpt_hdr.h	2008-08-07 15:37:22.000000000 -0700
> @@ -0,0 +1,69 @@
> +/*
> + *  Generic container checkpoint-restart
> + *
> + *  Copyright (C) 2008 Oren Laadan
> + *
> + *  This file is subject to the terms and conditions of the GNU General Public
> + *  License.  See the file COPYING in the main directory of the Linux
> + *  distribution for more details.
> + */
> +
> +#include <linux/types.h>
> +
> +struct cr_hdr {
> +	__s16 type;
> +	__s16 len;
> +	__u32 id;
> +};

Sorry for probably being out-of-date again, but isn't it better to
put these headers in the include/linux and export them to the user
space?

Why? Because we'll need some image-dumping tool (let alone the
image converting one for compatibility purposes) and these tools
would require to know how the image looks like.

Thanks,
Pavel

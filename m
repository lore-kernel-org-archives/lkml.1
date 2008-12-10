Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYLJF0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYLJF0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYLJF0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:26:03 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:62064 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYLJF0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:26:01 -0500
Date: Wed, 10 Dec 2008 13:25:55 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] rewrite the return method of static int
	s3c24xx_spi_setup(struct spi_device *spi) in
	drivers/spi/spi_s3c24xx.c
Message-ID: <20081210052554.GA7660@ubuntu>
References: <20081210030151.GA6404@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210030151.GA6404@helight>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 11:01:51AM +0800, Helight.Xu wrote:
>rewrite the return method of static int 
>s3c24xx_spi_setup(struct spi_device *spi) 
>in drivers/spi/spi_s3c24xx.c 
>
>reason:
>s3c24xx_spi_setupxfer(spi, NULL) return 0 or -EINVAL, 
>so here shoud return the ret,but only 0.

The original code can return the correct value.
It contains 0 and -EINVAL, not only 0. So this change is not essential.


-- 
Jianjun Kong |Happy Hacking
Homepage: http://kongove.cn
Gtalk:KongJianjun@gmail.com

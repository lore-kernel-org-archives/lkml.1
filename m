Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbXIKFEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbXIKFEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbXIKFEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:04:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941AbXIKFEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:04:38 -0400
Date: Mon, 10 Sep 2007 22:04:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: rpurdie@rpsys.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: add #include <linux/spinlock_types.h> to
 include/linux/leds.h for rwlock_t
Message-Id: <20070910220423.43e0a4d9.akpm@linux-foundation.org>
In-Reply-To: <20070904162345.30e82bc8.yoichi_yuasa@tripeaks.co.jp>
References: <20070904162345.30e82bc8.yoichi_yuasa@tripeaks.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2007 16:23:45 +0900 Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:

> 
> This patch has added #include <linux/spinlock_types.h> to include/linux/leds.h for rwlock_t.
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> 
> diff -pruN -X generic/Documentation/dontdiff generic-orig/include/linux/leds.h generic/include/linux/leds.h
> --- generic-orig/include/linux/leds.h	2007-09-04 14:59:51.334686250 +0900
> +++ generic/include/linux/leds.h	2007-09-04 14:56:10.676896000 +0900
> @@ -13,6 +13,7 @@
>  #define __LINUX_LEDS_H_INCLUDED
>  
>  #include <linux/list.h>
> +#include <linux/spinlock_types.h>
>  
>  struct device;
>  /*

I think spinlock_types.h is more an internal implementation detail, and
that leds.h should be including plain old <linux/spinlock.h>.  Does that
change also fix whatever build error you were seeing?

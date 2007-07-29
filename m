Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXG2Qqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXG2Qqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763873AbXG2Qqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:46:35 -0400
Received: from xenotime.net ([66.160.160.81]:38748 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762366AbXG2Qqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:46:35 -0400
Date: Sun, 29 Jul 2007 09:51:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/printk.c: make 2 variables static
Message-Id: <20070729095151.f5f96c99.rdunlap@xenotime.net>
In-Reply-To: <20070729145918.GG16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<20070729145918.GG16817@stusta.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 16:59:18 +0200 Adrian Bunk wrote:

> On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc6-mm1:
> >...
> > +slow-down-printk-during-boot.patch
> >...
> >  Misc
> >...
> 
> This patch makes two needlessly global variables static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Aye.  Thanks.

> ---
> --- linux-2.6.23-rc1-mm1/kernel/printk.c.old	2007-07-26 22:40:09.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/kernel/printk.c	2007-07-26 22:40:50.000000000 +0200
> @@ -166,8 +166,8 @@
>  
>  #ifdef CONFIG_BOOT_PRINTK_DELAY
>  
> -unsigned int boot_delay; /* msecs delay after each printk during bootup */
> -unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
> +static unsigned int boot_delay; /* msecs delay after each printk during bootup */
> +static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
>  
>  static int __init boot_delay_setup(char *str)
>  {


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

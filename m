Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYC0EA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYC0EA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 00:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbYC0EAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 00:00:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbYC0EAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 00:00:47 -0400
Date: Wed, 26 Mar 2008 21:00:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Give futex init a proper name
Message-Id: <20080326210038.e54b6180.akpm@linux-foundation.org>
In-Reply-To: <20080327035249.6F774DDF4D@ozlabs.org>
References: <20080327035249.6F774DDF4D@ozlabs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 14:52:15 +1100 Benjamin Herrenschmidt <benh@ozlabs.org> wrote:

> The futex init function is called init(). This is a pain in the neck
> when debugging when you code dies in ... init :-)
> 
> This renames it to futex_init().
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
>  kernel/futex.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-work.orig/kernel/futex.c	2008-03-27 14:50:11.000000000 +1100
> +++ linux-work/kernel/futex.c	2008-03-27 14:50:20.000000000 +1100
> @@ -2158,7 +2158,7 @@ static struct file_system_type futex_fs_
>  	.kill_sb	= kill_anon_super,
>  };
>  
> -static int __init init(void)
> +static int __init futex_init(void)
>  {
>  	u32 curval;
>  	int i;
> @@ -2194,4 +2194,4 @@ static int __init init(void)
>  
>  	return 0;
>  }
> -__initcall(init);
> +__initcall(futex_init);

heh, I seem to remember doing about fifty of these in netfilter code a
while back.

You have a way to go - there are thirty-odd just in the crypto code.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZCNOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZCNOwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZCNOwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:52:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZCNOwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:52:03 -0400
Subject: Re: [PATCH -tip] x86: i8257.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1237041815.4546.10.camel@ht.satnam>
References: <1237041815.4546.10.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:21:34 +0530
Message-Id: <1237042294.4546.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 20:13 +0530, Jaswinder Singh Rajput wrote:
> Subject: [PATCH] x86: i8257.c cleanup
> 

Oops, typo

It is [PATCH] x86: i8237.c cleanup

> Impact: cleanup
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/i8237.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
> index b42ca69..044ca09 100644
> --- a/arch/x86/kernel/i8237.c
> +++ b/arch/x86/kernel/i8237.c
> @@ -9,9 +9,8 @@
>   * your option) any later version.
>   */
>  
> -#include <linux/init.h>
>  #include <linux/sysdev.h>
> -
> +#include <linux/init.h>
>  #include <asm/dma.h>
>  
>  /*
> @@ -64,8 +63,10 @@ static struct sys_device device_i8237A = {
>  static int __init i8237A_init_sysfs(void)
>  {
>  	int error = sysdev_class_register(&i8237_sysdev_class);
> +
>  	if (!error)
>  		error = sysdev_register(&device_i8237A);
> +
>  	return error;
>  }
>  device_initcall(i8237A_init_sysfs);


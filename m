Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZFAF6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZFAF6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZFAF6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:58:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:49296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZFAF6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:58:34 -0400
Subject: Re: [RESEND][PATCH 1/2 -tip] headers_check fix: linux/auto_fs.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242795274.3260.4.camel@localhost.localdomain>
References: <1242795274.3260.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 11:20:16 +0530
Message-Id: <1243835416.3170.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 10:24 +0530, Jaswinder Singh Rajput wrote:
> fix the following 'make headers_check' warnings:
> 
>   usr/include/linux/auto_fs.h:17: include of <linux/types.h> is preferred over <asm/types.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/auto_fs.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
> index 6326585..7b09c83 100644
> --- a/include/linux/auto_fs.h
> +++ b/include/linux/auto_fs.h
> @@ -14,13 +14,12 @@
>  #ifndef _LINUX_AUTO_FS_H
>  #define _LINUX_AUTO_FS_H
>  
> +#include <linux/types.h>
>  #ifdef __KERNEL__
>  #include <linux/fs.h>
>  #include <linux/limits.h>
> -#include <linux/types.h>
>  #include <linux/ioctl.h>
>  #else
> -#include <asm/types.h>
>  #include <sys/ioctl.h>
>  #endif /* __KERNEL__ */
>  


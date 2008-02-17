Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYBQPGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYBQPGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbYBQPF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:05:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:20354 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613AbYBQPF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=N+pC+pC5s3pWdqyGND0W4Mog2IIUGn/7yQ30JD/ojLAAE6I/3hmLUF6Kyn7LJdcwXbrn28WQIlcsQkRp57tUnJTqwVjfAmeDR8jwg0momvnORENKz84kw5o1lac1X317JLejUWcuOv3bnaymn1fjsUOAaM1Fa+Ekz5u3SicNzc8=
Date: Sun, 17 Feb 2008 18:05:52 +0300
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: coding style fixes in arch/x86/lib/io_64.c
Message-ID: <20080217150552.GD6596@martell.zuzino.mipt.ru>
References: <20080217144116.5f146cfd@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217144116.5f146cfd@paolo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 02:41:16PM +0100, Paolo Ciarrocchi wrote:
> [PATCH] x86: coding style fixes in arch/x86/lib/io_64.c
> 
> This simple patch makes the file error free (according to
> checkpatch.pl)
> 
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  arch/x86/lib/io_64.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/lib/io_64.c b/arch/x86/lib/io_64.c
> index 87b4a4e..71fdf4b 100644
> --- a/arch/x86/lib/io_64.c
> +++ b/arch/x86/lib/io_64.c
> @@ -2,15 +2,15 @@
>  #include <asm/io.h>
>  #include <linux/module.h>
>  
> -void __memcpy_toio(unsigned long dst,const void*src,unsigned len)
> +void __memcpy_toio(unsigned long dst, const void*src, unsigned len)
                                               ^^^^^^^^
Please, fix all coding style violations so that nobody will do this in
next 5 years or so.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbXJ3WOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbXJ3WOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJ3WOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:14:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbXJ3WOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:14:03 -0400
Date: Tue, 30 Oct 2007 15:14:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/16] CRIS architecture: Correct compile errors
Message-Id: <20071030151400.e4769e27.akpm@linux-foundation.org>
In-Reply-To: <20071030092811.GD11960@axis.com>
References: <20071030092811.GD11960@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:28:11 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Remove include of asm/bitops.h, not needed here, corrects compilation error
> (__le64 undefined).
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  posix_types.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- clean_linux-2.6.23/include/asm-cris/posix_types.h	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/include/asm-cris/posix_types.h	2007-10-25 11:32:56.000000000 +0200
> @@ -52,7 +52,6 @@
>  } __kernel_fsid_t;
>  
>  #ifdef __KERNEL__
> -#include <asm/bitops.h>
>  
>  #undef	__FD_SET
>  #define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))
> 

This doesn't apply and I'm not sure that it is still needed or correct.

I'll drop it.

Please always prepare and test patches against the latest kernel.  2.6.23
is very much _not_ the latest kernel - there is a 50MB diff between 2.6.23
and 2.6.24-rc1.  That's a lot of difference.

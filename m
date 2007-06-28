Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXF1WOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXF1WOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763343AbXF1WNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:13:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145AbXF1WNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:13:53 -0400
Date: Thu, 28 Jun 2007 15:12:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: fix fallout from "remove sched.h from mm.h" patch
Message-Id: <20070628151257.7a03e81b.akpm@linux-foundation.org>
In-Reply-To: <20070628140921.GA9753@localhost.sw.ru>
References: <20070628140921.GA9753@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 18:09:21 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  include/asm-frv/pgtable.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/include/asm-frv/pgtable.h
> +++ b/include/asm-frv/pgtable.h
> @@ -25,7 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
> -struct mm_struct;
> +#include <linux/sched.h>
>  struct vm_area_struct;
>  #endif
>  

Please provide changelogs.

I assume this patch fixes some build error or something.


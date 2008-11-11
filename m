Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYKKAMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYKKAMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKKAMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:12:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbYKKAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:12:41 -0500
Date: Mon, 10 Nov 2008 16:12:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add include list.h in binfmts.h
Message-Id: <20081110161238.2f1ec110.akpm@linux-foundation.org>
In-Reply-To: <490907DE.2030502@ct.jp.nec.com>
References: <490907DE.2030502@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 18:03:26 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> linux_binfmt uses list_head, so list.h is needed.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  include/linux/binfmts.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 7394b5b..06c1123 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_BINFMTS_H
>  #define _LINUX_BINFMTS_H
>  
> +#include <linux/list.h>
>  #include <linux/capability.h>
>  
>  struct pt_regs;

Did this fix a build error which you were seeing?

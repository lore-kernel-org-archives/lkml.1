Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZJ2UOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZJ2UOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZJ2UOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:14:49 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:40597 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZJ2UOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:14:49 -0400
Date: Thu, 29 Oct 2009 23:13:29 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] ufs: NFS support
Message-ID: <20091029201329.GA30767@rain>
Mail-Followup-To: Alexey Dobriyan <adobriyan@gmail.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20091029101718.GB27166@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029101718.GB27166@x200>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 01:17:18PM +0300, Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  fs/ufs/super.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -66,6 +66,7 @@
>   */
>  
>  
> +#include <linux/exportfs.h>
>  	sb->s_op = &ufs_super_ops;
...
> +	sb->s_export_op = &ufs_export_ops;
>  	sb->dq_op = NULL; /***/
>  	sb->s_magic = fs32_to_cpu(sb, usb3->fs_magic);
>  

I created the similar patch a couple of years ago, for one
person, but have no enough energy to fully test it, before
pushing into mainline.

Acked-by: Evgeniy Dushistov <dushistov@mail.ru>

-- 
/Evgeniy


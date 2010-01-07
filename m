Return-Path: <linux-kernel-owner+w=401wt.eu-S932644Ab0AGAbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0AGAbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004Ab0AGAbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:31:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab0AGAbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:31:45 -0500
Date: Wed, 6 Jan 2010 16:31:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH V2 6/8] lzma: Make lzma available to non
 initramfs/initrd code
Message-Id: <20100106163113.637e47db.akpm@linux-foundation.org>
In-Reply-To: <4B4528C8.3020603@lougher.demon.co.uk>
References: <E1NIuOW-0001ol-RC@dylan.lougher.demon.co.uk>
	<20100106140409.ba0f63d1.akpm@linux-foundation.org>
	<4B4528C8.3020603@lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010 00:20:24 +0000
Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> Andrew Morton wrote:
> 
> > So what to do?  I guess I could go ahead with the mainline merge, and
> > Stephen drops <whatever that tree was> from linux-next until it has
> > been fixed up?
> > 
> 
> Yes, I'm happy with that.  The following patch is the necessary fix
> that needs to go into linux-next when you've gone ahead with the
> mainline merge of the lib-add-support-for-lzo-compressed-kernels.patch.

ooh, goody, thanks.

> diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
> index db521f4..edd82c3 100644
> --- a/lib/decompress_unlzo.c
> +++ b/lib/decompress_unlzo.c
> @@ -39,6 +39,7 @@
> 
>   #include <linux/types.h>
>   #include <linux/lzo.h>
> +#include <linux/decompress/unlzo_mm.h>
>   #include <linux/decompress/mm.h>
> 
>   #include <linux/compiler.h>

Your email client is doing space-stuffing.

Return-Path: <linux-kernel-owner+w=401wt.eu-S945405AbXHMMqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945405AbXHMMqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965288AbXHMH25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:28:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25533 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939726AbXHMH2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:28:54 -0400
Date: Mon, 13 Aug 2007 09:28:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [95/2many] MAINTAINERS - BLOCK LAYER
Message-ID: <20070813072851.GD23758@kernel.dk>
References: <46bff917.EmblDII2NfX3zJ2k%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bff917.EmblDII2NfX3zJ2k%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12 2007, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7b84921..912950f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -960,6 +960,7 @@ M:	axboe@kernel.dk
>  L:	linux-kernel@vger.kernel.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
>  S:	Maintained
> +F:	drivers/block/

drivers/block/ is block device drivers, not the block layer. That mostly
resides in block/, with some parts in fs/ as well.

-- 
Jens Axboe


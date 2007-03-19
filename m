Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbXCSAgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbXCSAgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 20:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbXCSAgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 20:36:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2821 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751003AbXCSAgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 20:36:50 -0400
Date: Sun, 18 Mar 2007 20:36:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ralf Baechle <ralf@linux-mips.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix build error due to not including <linux/errno.h>
In-Reply-To: <20070318125808.GA25840@linux-mips.org>
Message-ID: <Pine.LNX.4.44L0.0703182036060.17900-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Ralf Baechle wrote:

> Since d9a9cdfb078d755e648d53ec25b7370f84ee5729 <linux/sysfs.h> is using
> ENOSYS without including <linux/errno.h> if CONFIG_SYSFS is disabled.
> 
> Fixed by including <linux/errno.h>.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 0544edd..fea9a6b 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -11,6 +11,7 @@
>  #define _SYSFS_H_
>  
>  #include <linux/compiler.h>
> +#include <linux/errno.h>
>  #include <linux/list.h>
>  #include <asm/atomic.h>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thank you for spotting and fixing this.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S965402AbXBFAsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402AbXBFAsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXBFAsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:48:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:55648 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965402AbXBFAsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:48:09 -0500
Date: Mon, 5 Feb 2007 16:43:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][1/5] floppy.c: Initial (partial) CodingStyle cleanup
Message-Id: <20070205164329.8f1eca97.randy.dunlap@oracle.com>
In-Reply-To: <200702060028.50439.jesper.juhl@gmail.com>
References: <200702060028.50439.jesper.juhl@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 00:28:50 +0100 Jesper Juhl wrote:

> 
> This is a basic CodingStyle cleanup for drivers/block/floppy.c
> 
> There are no functional changes in this patch. 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  floppy.c |  203 ++++++++++++++++++++++++-----------------------------
>  1 file changed, 94 insertions(+), 109 deletions(-)
> 
> --- linux-2.6.20-orig/drivers/block/floppy.c	2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6.20/drivers/block/floppy.c	2007-02-05 23:08:39.000000000 +0100
> @@ -1252,8 +1258,8 @@
>  			DPRINT("Invalid data rate for perpendicular mode!\n");
>  			cont->done(0);
>  			FDCS->reset = 1;	/* convenient way to return to
> -						 * redo without to much hassle (deep
> -						 * stack et al. */
> +						 * redo without to much hassle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> too
> +						 * (deep stack et al. */
>  			return;
>  		}
>  	} else


---
~Randy

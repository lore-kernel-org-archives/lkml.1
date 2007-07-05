Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbXGER5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbXGER5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbXGER5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:57:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41329 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760457AbXGER5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:57:32 -0400
Date: Thu, 5 Jul 2007 10:59:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] drivers/block/rd.c: lower printk severity
Message-Id: <20070705105942.ec6396fe.randy.dunlap@oracle.com>
In-Reply-To: <93d7a361198aac1cdb9bbfe556ae60faa40ff36c.1183551645.git.da-x@monatomic.org>
References: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
	<93d7a361198aac1cdb9bbfe556ae60faa40ff36c.1183551645.git.da-x@monatomic.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007 15:30:22 +0300 Dan Aloni wrote:

> Signed-off-by: Dan Aloni <da-x@monatomic.org>
> ---
>  drivers/block/rd.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/rd.c b/drivers/block/rd.c
> index a1512da..3b974f8 100644
> --- a/drivers/block/rd.c
> +++ b/drivers/block/rd.c
> @@ -463,9 +463,9 @@ static int __init rd_init(void)
>  	}
>  
>  	/* rd_size is given in kB */
> -	printk("RAMDISK driver initialized: "
> -		"%d RAM disks of %dK size %d blocksize\n",
> -		CONFIG_BLK_DEV_RAM_COUNT, rd_size, rd_blocksize);
> +	printk(KERN_INFO "RAMDISK driver initialized: "
> +	       "%d RAM disks of %dK size %d blocksize\n",
> +	       CONFIG_BLK_DEV_RAM_COUNT, rd_size, rd_blocksize);
>  
>  	return 0;
>  out:
> -- 

Hi Dan,
All of the changes look good to me except for this one.
The change to use 7 spaces to align the strings is unnecessary.

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

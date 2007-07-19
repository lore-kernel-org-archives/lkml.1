Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbXGSL6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbXGSL6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbXGSL6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:58:35 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:33092 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbXGSL6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:58:34 -0400
X-Greylist: delayed 1533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 07:58:34 EDT
Message-ID: <469F4BEC.6020500@vandrovec.name>
Date: Thu, 19 Jul 2007 04:33:00 -0700
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NCP:  Delete test of long-deceased CONFIG_NCPFS_DEBUGDENTRY.
References: <Pine.LNX.4.64.0707190706300.24493@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707190706300.24493@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Fine with me.  Thanks.

Acked-by: Petr Vandrovec <petr@vandrovec.name>

> ---
> 
>   steve walks warily down the street with the brim pulled way down low
> ...
> 
> 
> diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
> index 551e0ba..df6d60b 100644
> --- a/fs/ncpfs/ncplib_kernel.c
> +++ b/fs/ncpfs/ncplib_kernel.c
> @@ -726,9 +726,6 @@ ncp_del_file_or_subdir2(struct ncp_server *server,
>  	__le32 dirent;
> 
>  	if (!inode) {
> -#ifdef CONFIG_NCPFS_DEBUGDENTRY
> -		PRINTK("ncpfs: ncpdel2: dentry->d_inode == NULL\n");
> -#endif
>  		return 0xFF;	/* Any error */
>  	}
>  	volnum = NCP_FINFO(inode)->volNumber;



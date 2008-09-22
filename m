Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYIVPbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYIVPbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIVPay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:30:54 -0400
Received: from xenotime.net ([66.160.160.81]:34372 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752697AbYIVPay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:30:54 -0400
Date: Mon, 22 Sep 2008 08:30:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marco Stornelli <marco.stornelli@coritel.it>
Cc: mtk.manpages@gmail.com, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] documentation: xip documentation update
Message-Id: <20080922083050.3ec7b7e9.rdunlap@xenotime.net>
In-Reply-To: <48D76770.9000808@coritel.it>
References: <48D76770.9000808@coritel.it>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 11:37:52 +0200 Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> xip documentation updated
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> --- linux-2.6.26.5/Documentation/filesystems/xip.txt.orig	2008-08-20 20:11:37.000000000 +0200
> +++ linux-2.6.26.5/Documentation/filesystems/xip.txt	2008-09-22 11:27:46.000000000 +0200
> @@ -39,10 +39,11 @@ The block device operation is optional,
>  today:
>  - dcssblk: s390 dcss block device driver
>  
> -An address space operation named get_xip_page is used to retrieve reference
> -to a struct page. To address the target page, a reference to an address_space,
> -and a sector number is provided. A 3rd argument indicates whether the
> -function should allocate blocks if needed.
> +An address space operation named get_xip_mem is used to retrieve reference
> +to a page frame number and a kernel address. To obtain these values a reference
> +to an address_space is provided. This function is in charge to assign values to

How about:
                                    This function assigns values to the kmem and
   pfn parameters.

> +the pointers kmem and pfn. The 3rd argument indicates whether the function 
> +should allocate blocks if needed.
>  
>  This address space operation is mutually exclusive with readpage&writepage that
>  do page cache read/write operations.


Thanks.

---
~Randy

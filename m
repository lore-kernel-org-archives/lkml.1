Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbXJXRYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbXJXRYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXJXRYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:24:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53998 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbXJXRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:24:20 -0400
Subject: Re: [2.6 patch] mm/hugetlb.c: make a function static
From: Adam Litke <agl@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162349.GX30533@stusta.de>
References: <20071024162349.GX30533@stusta.de>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 12:24:14 -0500
Message-Id: <1193246654.18417.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 18:23 +0200, Adrian Bunk wrote:
> return_unused_surplus_pages() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Adam Litke <agl@us.ibm.com>

> 
> ---
> 8932fe99341629d50863643229d25666e9f44e03 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8b809ec..b65da0d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -323,7 +323,7 @@ free:
>   * allocated to satisfy the reservation must be explicitly freed if they were
>   * never used.
>   */
> -void return_unused_surplus_pages(unsigned long unused_resv_pages)
> +static void return_unused_surplus_pages(unsigned long unused_resv_pages)
>  {
>  	static int nid = -1;
>  	struct page *page;
> 
> 
-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center


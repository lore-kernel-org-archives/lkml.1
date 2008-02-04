Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYBDJdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYBDJdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYBDJdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:33:07 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4407 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYBDJdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:33:06 -0500
Date: Mon, 4 Feb 2008 09:33:51 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: minchan kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modify incorrected word in comment of clear_active_flags
Message-ID: <20080204093351.GD14362@shadowen.org>
References: <28c262360802012236w3a1b4253h2a6ad96570d4a634@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28c262360802012236w3a1b4253h2a6ad96570d4a634@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:36:54PM +0900, minchan kim wrote:
> I think is was a mistake.
> clear_active_flags is just called by shrink_inactive_list.
> 
> --- mm/vmscan.c.orig  2008-02-02 15:21:52.000000000 +0900
> +++ mm/vmscan.c 2008-02-02 15:20:46.000000000 +0900
> @@ -761,7 +761,7 @@ static unsigned long isolate_lru_pages(u
>  }
> 
>  /*
> - * clear_active_flags() is a helper for shrink_active_list(), clearing
> + * clear_active_flags() is a helper for shrink_inactive_list(), clearing
>   * any active bits from the pages in the list.
>   */
>  static unsigned long clear_active_flags(struct list_head *page_list)

Yeah that is a silly typo.

Acked-by: Andy Whitcroft <apw@shadowen.org>

-apw

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103Ab0AZAm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0AZAm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745Ab0AZAm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:42:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:46612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab0AZAmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:42:54 -0500
Date: Tue, 26 Jan 2010 01:42:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Pitre <nico@marvell.com>
Subject: Re: [PATCH] trivial grammar fix: if and only if
In-Reply-To: <1264451889-10234-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1001260142380.30977@pobox.suse.cz>
References: <1264451889-10234-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Uwe Kleine-König wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Nicolas Pitre <nico@marvell.com>
> ---
>  mm/highmem.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index 9c1e627..bed8a8b 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -220,7 +220,7 @@ EXPORT_SYMBOL(kmap_high);
>   * @page: &struct page to pin
>   *
>   * Returns the page's current virtual memory address, or NULL if no mapping
> - * exists.  When and only when a non null address is returned then a
> + * exists.  If and only if a non null address is returned then a
>   * matching call to kunmap_high() is necessary.
>   *
>   * This can be called from any context.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

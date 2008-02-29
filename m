Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYB2Lyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYB2Lyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYB2LyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:54:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39461 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYB2LyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:54:24 -0500
Date: Fri, 29 Feb 2008 20:53:45 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 05/21] define page_file_cache() function
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
In-Reply-To: <20080228192928.335536700@redhat.com>
References: <20080228192908.126720629@redhat.com> <20080228192928.335536700@redhat.com>
Message-Id: <20080229204230.670B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Index: linux-2.6.25-rc2-mm1/mm/swap_state.c
> ===================================================================
> --- linux-2.6.25-rc2-mm1.orig/mm/swap_state.c	2008-02-19 16:23:09.000000000 -0500
> +++ linux-2.6.25-rc2-mm1/mm/swap_state.c	2008-02-27 14:36:57.000000000 -0500
> @@ -82,6 +82,7 @@ int add_to_swap_cache(struct page *page,
>  		if (!error) {
>  			page_cache_get(page);
>  			SetPageSwapCache(page);
> +			SetPageSwapBacked(page);
>  			set_page_private(page, entry.val);
>  			total_swapcache_pages++;
>  			__inc_zone_page_state(page, NR_FILE_PAGES);

hmm,
What do you think NR_FILE_PAGES counted?
SetPageSwapBacked() and increase NR_FILE_PAGES is a bit strange.

but I am worried now.
because if change it, make a incompatibility... ;)


- kosaki



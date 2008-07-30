Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYG3Ohl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYG3Ohl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYG3Ohd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:37:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYG3Ohc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:37:32 -0400
Message-ID: <48907C9E.3050301@linux-foundation.org>
Date: Wed, 30 Jul 2008 09:37:18 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] madvise: update function comment of madvise_dontneed
References: <1217243241.3087.6.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1217243241.3087.6.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.26/mm/madvise.c linux-2.6.26-fixes/mm/madvise.c
> --- linux-2.6.26/mm/madvise.c	2008-07-14 06:51:29.000000000 +0900
> +++ linux-2.6.26-fixes/mm/madvise.c	2008-07-28 19:53:27.000000000 +0900
> @@ -132,10 +132,10 @@ static long madvise_willneed(struct vm_a
>   * Application no longer needs these pages.  If the pages are dirty,
>   * it's OK to just throw them away.  The app will be more careful about
>   * data it wants to keep.  Be sure to free swap resources too.  The
> - * zap_page_range call sets things up for refill_inactive to actually free
> + * zap_page_range call sets things up for shrink_active_list to actually free
>   * these pages later if no one else has touched them in the meantime,
>   * although we could add these pages to a global reuse list for
> - * refill_inactive to pick up before reclaiming other pages.
> + * shrink_active_list to pick up before reclaiming other pages.
>   *
>   * NB: This interface discards data rather than pushes it out to swap,
>   * as some implementations do.  This has performance implications for
> 
> 

Well shrink_page_list actually does the freeing of the pages.


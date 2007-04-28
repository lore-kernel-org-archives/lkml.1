Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXD1A12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXD1A12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXD1A11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:27:27 -0400
Received: from gw.goop.org ([64.81.55.164]:51561 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757964AbXD1A10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:27:26 -0400
Message-ID: <463294EE.5060006@goop.org>
Date: Fri, 27 Apr 2007 17:27:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bbpetkov@yahoo.de, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized spinlock.
 was: Re: 2.6.21-rc7-mm2
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org>
In-Reply-To: <20070427172230.94b82829.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> --- a/mm/memory.c~add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix
> +++ a/mm/memory.c
> @@ -1455,7 +1455,7 @@ static int apply_to_pte_range(struct mm_
>  	pte_t *pte;
>  	int err;
>  	struct page *pmd_page;
> -	spinlock_t *ptl;
> +	spinlock_t *ptl = ptl;		/* Suppress gcc warning */
>  

Sigh.  I guess so.

    J

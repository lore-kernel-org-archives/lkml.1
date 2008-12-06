Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYLFMMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYLFMMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYLFMMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:12:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:33729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbYLFMMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:12:33 -0500
Date: Sat, 6 Dec 2008 13:12:27 +0100
From: Nick Piggin <npiggin@suse.de>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Fix incorrect use of loose in migrate.c
Message-ID: <20081206121227.GA6292@wotan.suse.de>
References: <20081205030807.32309.69191.stgit@marcab.local.tull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205030807.32309.69191.stgit@marcab.local.tull.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 02:08:07PM +1100, Nick Andrew wrote:
> Fix incorrect use of loose in migrate.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> ---
> 
>  mm/migrate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1e0d6b2..7605b2b 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -514,7 +514,7 @@ static int writeout(struct address_space *mapping, struct page *page)
>  	/*
>  	 * A dirty page may imply that the underlying filesystem has
>  	 * the page on some queue. So the page must be clean for
> -	 * migration. Writeout may mean we loose the lock and the
> +	 * migration. Writeout may mean we lose the lock and the
>  	 * page state is no longer what we checked for earlier.
>  	 * At this point we know that the migration attempt cannot
>  	 * be successful.

I don't know... presumably we haven't just gone and lost the little
bugger. I mean, we were holding it one minute, then... gone?  Do we
have Alzheimer's? Unlikely. I think we loosed it.


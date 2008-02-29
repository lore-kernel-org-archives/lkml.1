Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbYB2Osx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbYB2Osx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759163AbYB2Oso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:48:44 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:42230 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbYB2Oso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:48:44 -0500
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: minchan Kim <barrioskmc@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <44c63dc40802282058h67f7597bvb614575f06c62e2c@mail.gmail.com>
References: <20080228192908.126720629@redhat.com>
	 <20080228192929.031646681@redhat.com>
	 <44c63dc40802282058h67f7597bvb614575f06c62e2c@mail.gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 29 Feb 2008 09:48:54 -0500
Message-Id: <1204296534.5311.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 13:58 +0900, minchan Kim wrote:
>         
>         +#ifdef CONFIG_NORECLAIM
>         +static inline void lru_cache_add_noreclaim(struct page *page)
>         +{
>         +       __lru_cache_add(page, LRU_NORECLAIM);
>         +}
>         +#else
>         +static inline void lru_cache_add_noreclaim(struct page *page)
>         +{
>         +       BUG("Noreclaim not configured, but page added
>         anyway?!");
>         +}
>         +#endif
>         +
> 
> BUG() can't take a argument. 

Right.  I don't have a clue how that got there :-(.

Thanks,
Lee


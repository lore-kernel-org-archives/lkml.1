Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYEEUUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYEEUUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758007AbYEEUUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:20:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51974 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYEEUUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:20:35 -0400
Date: Mon, 5 May 2008 23:19:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mm/hugetlb.c: fix duplicate variable
Message-ID: <20080505201927.GB1544@cs181133002.pp.htv.fi>
References: <20080505182816.GN17139@cs181133002.pp.htv.fi> <2f11576a0805051311m60c0dfb5k56c04d5f4ddc04e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2f11576a0805051311m60c0dfb5k56c04d5f4ddc04e8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:11:10AM +0900, KOSAKI Motohiro wrote:
> > It's confusing that set_max_huge_pages() contained two different
> >  variables named "ret", and although the code works correctly this should
> >  be fixed.
> >
> >  The inner of the two variables can simply be removed.
>                             ^^^^
> 
> two?
> I think removal inner variable is 1, no?

Two people for whom English is not the native language are trying to 
understand each other...  ;)

There were two variables.

And my patch removes the inner one inside the loop, not the outer one 
that is valid within the whole function.

> but, your change is perfectly right, IMHO.
> 
>            Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> >         while (count > persistent_huge_pages) {
> >  -               int ret;
> >                 /*
> >                  * If this allocation races such that we no longer need the
> >                  * page, free_huge_page will handle it by freeing the page
> >                  * and reducing the surplus.
> >                  */

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


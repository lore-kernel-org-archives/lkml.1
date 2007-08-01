Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbXHAJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbXHAJ3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXHAJ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:29:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56336 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316AbXHAJ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:29:30 -0400
Date: Wed, 1 Aug 2007 11:29:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
Message-ID: <20070801092909.GN3972@stusta.de>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 11:06:46AM +0200, Miklos Szeredi wrote:
> I wonder why we don't have type safe object allocators a-la new() in
> C++ or g_new() in glib?
> 
>   fooptr = k_new(struct foo, GFP_KERNEL);
> 
> is nicer and more descriptive than
> 
>   fooptr = kmalloc(sizeof(*fooptr), GFP_KERNEL);
>...

But it's much more likely to break when someone converts fooptr to a 
different struct.

It might not be a common case but it sometimes happens - and your type 
safe variant introduces the possibility for really nasty bugs.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


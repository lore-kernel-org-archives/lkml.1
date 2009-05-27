Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZE0Ukl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZE0Ukl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZE0Uk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:40:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395AbZE0UkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:40:25 -0400
Date: Wed, 27 May 2009 13:38:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: minchan.kim@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
       hannes@cmpxchg.org, y-goto@jp.fujitsu.com
Subject: Re: [PATCH 1/3]  clean up functions related to pages_min V2
Message-Id: <20090527133845.a26df9cb.akpm@linux-foundation.org>
In-Reply-To: <20090527202955.2260a232.minchan.kim@barrios-desktop>
References: <20090521092304.0eb3c4cb.minchan.kim@barrios-desktop>
	<20090526222510.ad054b8a.akpm@linux-foundation.org>
	<20090527202955.2260a232.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 20:29:55 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> This patch change names of two functions. so It doesn't affect behavior. 
> Now, setup_per_zone_pages_min changes low, high of zone as well as min.
> So, a better name might have been setup_per_zone_wmarks.That's because
> Mel changed zone->pages_[hig/low/min] to zone->watermark array.(434b5394fd85c212619306cda6bf087be737b35a)
> 

When quoting changeset IDs, please do it in the form

  0594ad1a66381076f0fa06f5605ea5023f600586 ("mfd/pcf50633-gpio.c: add MODULE_LICENSE")

There's a good reason for this, but I forget what it is.  Perhaps so
that the same commit can be located if it has a different hash?  I
expect that commits get a different hash when backported into -stable,
for example.

I spend my life making changes like that to changelogs, but when I went
to fix up your 434b5394fd85c212619306cda6bf087be737b35a, I was unable
to locate any commit which has that hash.

<searches for a while>

Ah, you're referring to a -mmotm patch.  The hashes in -mmotm aren't
useful because the tree gets regenerated each time.  So let's refer to
that patch via just its title, "page allocator: replace the
watermark-related union in struct zone with a watermark[] array".



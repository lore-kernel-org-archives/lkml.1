Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZE0F0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZE0F0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbZE0F0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:26:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754196AbZE0F0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:26:05 -0400
Date: Tue, 26 May 2009 22:25:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 1/3]  clean up functions related to pages_min V2
Message-Id: <20090526222510.ad054b8a.akpm@linux-foundation.org>
In-Reply-To: <20090521092304.0eb3c4cb.minchan.kim@barrios-desktop>
References: <20090521092304.0eb3c4cb.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 09:23:04 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:

> Changelog since V1 
>  o Change function name from setup_per_zone_wmark_min to setup_per_zone_wmarks
>    - by Mel Gorman advise
>  o Modify description - by KOSAKI advise
> 
> Mel changed zone->pages_[high/low/min] with zone->watermark array.
> So, the functions related to pages_min also have to be changed.
> 
> * setup_per_zone_pages_min
> * init_per_zone_pages_min
> 
> This patch is just clean up. so it doesn't affect behavior.
> 

I cannot actually find a usable changelog amongst all that text.  Can
you try again please?

afacit the patch simply changes the names of a couple of functions. 
The changelog should concisely and completely describe what those naming
changes are, and the reason for making them.


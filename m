Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZEFGvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZEFGvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZEFGvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:51:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:48173 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZEFGvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Bh7ca0LVt95XdvIq7AvqdPrYtPVGpeyTWoTn1TE4Dxmo8m3MBjs5mO1eHUuXhic2Fd
         Z4TAkUndY/i9JvK9JtNW1PETIs8graAs+y41bvDGE5pjIanw9MS/I3CdPMoFOP2lYauZ
         asPy52uyc/mTbPyYP4/KqmwOiVZT4OBlYOvLk=
Date: Wed, 6 May 2009 15:51:45 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, LMMML <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mmotm] mm: setup_per_zone_inactive_ratio - fix comment
 and make it __init
Message-Id: <20090506155145.e657b271.minchan.kim@barrios-desktop>
In-Reply-To: <20090506061923.GA4865@lenovo>
References: <20090506061923.GA4865@lenovo>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 10:19:23 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> The caller of setup_per_zone_inactive_ratio is module_init function.

__init :)

> No need to keep the callee after is completed as well.
> Also fix a comment.
> 
> CC: David Rientjes <rientjes@google.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
I guess the comment was a typo. 

> ---
>  mm/page_alloc.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Index: linux-2.6.git/mm/page_alloc.c
> =====================================================================
> --- linux-2.6.git.orig/mm/page_alloc.c
> +++ linux-2.6.git/mm/page_alloc.c
> @@ -4540,8 +4540,6 @@ void setup_per_zone_pages_min(void)
>  }
>  
>  /**
> - * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
> - *
>   * The inactive anon list should be small enough that the VM never has to
>   * do too much work, but large enough that each inactive page has a chance
>   * to be referenced again before it is swapped out.
> @@ -4562,7 +4560,7 @@ void setup_per_zone_pages_min(void)
>   *    1TB     101        10GB
>   *   10TB     320        32GB
>   */
> -static void setup_per_zone_inactive_ratio(void)
> +static void __init setup_per_zone_inactive_ratio(void)
>  {
>  	struct zone *zone;
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


-- 
Kinds Regards
Minchan Kim

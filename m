Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbZGIKWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbZGIKWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZGIKW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:22:28 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:54834 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZGIKW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Se34MG67cwlEw9WltQya2NB3giFYszp9Qqp9n5TpZfJLxMsWlj308srn5OTRERk/LK
         cO5xrDMtuGvMLMWg8/2pUsHze1ZXM1IHviOYrdlL1mdc1UVuOfV1c64IyFUWmEqEOntW
         o6ci3DGaSSXNiOdc+GvdlKGybsAK5inXy2+IU=
MIME-Version: 1.0
In-Reply-To: <20090709171247.23C6.A69D9226@jp.fujitsu.com>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
	 <20090709171247.23C6.A69D9226@jp.fujitsu.com>
Date: Thu, 9 Jul 2009 19:22:26 +0900
Message-ID: <28c262360907090322u55ba7a1blea49c6063bbee528@mail.gmail.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 5:14 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> ChangeLog
>  Since v4
>   - Changed displaing order in show_free_areas() (as Wu's suggested)
>  Since v3
>   - Fixed misaccount page bug when lumby reclaim occur
>  Since v2
>   - Separated IsolateLRU field to Isolated(anon) and Isolated(file)
>  Since v1
>   - Renamed IsolatePages to IsolatedLRU
>
> ==================================
> Subject: [PATCH] add isolate pages vmstat
>
> If the system have plenty threads or processes, concurrent reclaim can
> isolate very much pages.
> Unfortunately, current /proc/meminfo and OOM log can't show it.
>
> This patch provide the way of showing this information.
>
>
> reproduce way
> -----------------------
> % ./hackbench 140 process 1000
>   => couse OOM
>
> active_anon:146 inactive_anon:0 isolated_anon:49245
>  active_file:41 inactive_file:0 isolated_file:113
>  unevictable:0
>  dirty:0 writeback:0 buffer:49 unstable:0
>  free:184 slab_reclaimable:276 slab_unreclaimable:5492
>  mapped:87 pagetables:28239 bounce:0
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZGPORa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZGPORa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZGPOR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:17:29 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:60257 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbZGPOR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tsIBoJ6I/iCbaYKrHu1RUSZ4Pvf06qDsWqdUzx0n9YQZbmXvMFdeq5djNsUvIT/a5f
         G3LuzfXmCdHy4kcDO9ImHiykk9BgVZaerPeILfFAf22vytMVL+MhJvbHstGaakAELqKe
         0v2MzHVe6tTt0JXzg34Q8QRVtqpmQDw1CAvSI=
MIME-Version: 1.0
In-Reply-To: <20090716133454.GA20550@localhost>
References: <20090716133454.GA20550@localhost>
Date: Thu, 16 Jul 2009 23:17:28 +0900
Message-ID: <28c262360907160717p5cb3f3d8y5b3ced96e3824ef8@mail.gmail.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Wu.
I already agreed this concept.
Wow, It looks better than old. :)

On Thu, Jul 16, 2009 at 10:34 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> global_lru_pages() / zone_lru_pages() can be used in two ways:
> - to estimate max reclaimable pages in determine_dirtyable_memory()
> - to calculate the slab scan ratio
>
> When swap is full or not present, the anon lru lists are not reclaimable
> and thus won't be scanned. So the anon pages shall not be counted. Also
> rename the function names to reflect the new meaning.
>
> It can greatly (and correctly) increase the slab scan rate under high memory
> pressure (when most file pages have been reclaimed and swap is full/absent),
> thus avoid possible false OOM kills.
>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim

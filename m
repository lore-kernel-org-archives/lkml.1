Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZE0GFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZE0GFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZE0GFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:05:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:50779 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZE0GFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=SiGg7L6rZvUWEFua03TOnfVyXEYrYsp311WpAEcf5t4lAyIAHTwlI4CpMSyMR1OdKk
         H4Bsv/J+z2gLbOWkHn64UeCn1SeJ0KZ78d7khQIYSy6TsqJXrHew4Z6JBhLSqduaD75L
         baDt69Pz90Ww3qsxZ8rU66U6lJiHk84JYIZ7Y=
Date: Wed, 27 May 2009 15:05:08 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] add inactive ratio calculation function of each
 zone V2
Message-Id: <20090527150508.2ce7e57b.minchan.kim@barrios-desktop>
In-Reply-To: <20090526223002.f283bcd2.akpm@linux-foundation.org>
References: <20090521092321.ee57585e.minchan.kim@barrios-desktop>
	<20090526223002.f283bcd2.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 22:30:02 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 21 May 2009 09:23:21 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > Changelog since V1 
> >  o Change function name from calculate_zone_inactive_ratio to calculate_inactive_ratio
> >    - by Mel Gorman advise
> >  o Modify tab indent - by Mel Gorman advise
> 
> The first two patches still had various trivial whitespace bustages. 
> You don't need Mel to find these things when we have the very nice
> scripts/checkpatch.pl.  Please incorporate that script into your patch
> preparation tools

Oops. I thought I tried to do checkpatch.pl with my patches. 

> > This patch devide setup_per_zone_inactive_ratio with
> > per-zone inactive ratio calculaton.
> 
> The above sentence appears to be the changelog for this patch but it
> doesn't make a lot of sense.
> 
> afaict the changelog should be:
> 
> "factor the per-zone arithemetic inside
> setup_per_zone_inactive_ratio()'s loop into a a separate function,
> calculate_zone_inactive_ratio().  This function will be used in a later
> patch".
> 
> yes?

Exactly. 

I will repost this with your improved changelog.
Thanks. Andrew.



-- 
Kinds Regards
Minchan Kim

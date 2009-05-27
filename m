Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZE0GH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZE0GH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbZE0GHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:07:12 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:5889 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbZE0GHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ZtMKaaBTOCbAfJtmVqijIqHousFihw404sZ+mdcytq3T4qPfCzagGCHiRnHDmp2VcP
         7BZJWNn01tYvK+BUDo0hKbdxvSScJn+RU6lBoSsIsz6WsgPnVJ8djQoB/OYHmNNk/fYc
         TpxOGCB+P+/Gm/0a4KgwmWf2MgxoSW41mrksY=
Date: Wed, 27 May 2009 15:06:41 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 1/3]  clean up functions related to pages_min V2
Message-Id: <20090527150641.5f1eef75.minchan.kim@barrios-desktop>
In-Reply-To: <20090526222510.ad054b8a.akpm@linux-foundation.org>
References: <20090521092304.0eb3c4cb.minchan.kim@barrios-desktop>
	<20090526222510.ad054b8a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 22:25:10 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 21 May 2009 09:23:04 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > Changelog since V1 
> >  o Change function name from setup_per_zone_wmark_min to setup_per_zone_wmarks
> >    - by Mel Gorman advise
> >  o Modify description - by KOSAKI advise
> > 
> > Mel changed zone->pages_[high/low/min] with zone->watermark array.
> > So, the functions related to pages_min also have to be changed.
> > 
> > * setup_per_zone_pages_min
> > * init_per_zone_pages_min
> > 
> > This patch is just clean up. so it doesn't affect behavior.
> > 
> 
> I cannot actually find a usable changelog amongst all that text.  Can
> you try again please?
> 
> afacit the patch simply changes the names of a couple of functions. 
> The changelog should concisely and completely describe what those naming
> changes are, and the reason for making them.
> 

Okay. I will do that :)

-- 
Kinds Regards
Minchan Kim

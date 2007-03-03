Return-Path: <linux-kernel-owner+w=401wt.eu-S2992952AbXCCDEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992952AbXCCDEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992955AbXCCDEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:04:45 -0500
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:60671 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992952AbXCCDEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:04:43 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Rik van Riel <riel@redhat.com>, ck list <ck@vds.kolivas.org>
Subject: Re: [PATCH] free swap space of (re)activated pages
Date: Sat, 3 Mar 2007 14:04:20 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
References: <45E88997.4050308@redhat.com> <20070302171818.d271348e.akpm@linux-foundation.org> <45E8CFD8.7050808@redhat.com>
In-Reply-To: <45E8CFD8.7050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703031404.21064.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007 12:31, Rik van Riel wrote:
> Andrew Morton wrote:
> > On Fri, 02 Mar 2007 15:31:19 -0500
> >
> > Rik van Riel <riel@redhat.com> wrote:
> >> the attached patch frees the swap space of already resident pages
> >> when swap space starts getting tight, instead of only freeing up
> >> the swap space taken up by newly swapped in pages.
> >>
> >> This should result in the swap space of pages that remain resident
> >> in memory being freed, allowing kswapd more chances to actually swap
> >> a page out (instead of rotating it back onto the active list).
> >
> > Fair enough.   How do we work out if this helps things?
>
> I suspect it should mostly help on desktop systems that slowly
> fill up (and run out of) swap.  I'm not sure how to create that
> synthetically.

Ooh you have a vm patch that helps swap on the desktop! I can help you here 
with my experience from swap prefetch.

1. Get it reviewed and have noone show any evidence it harms
2. Find hundreds of users who can testify it helps
3. Find a way of quantifying it.
4. ...
5. Merge into mainline.


There, that should get you as far as 4. 

I haven't figured out what 4 is yet. I believe it may be goto 1;

-- 
-ck

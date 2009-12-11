Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbZLKAgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbZLKAgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZLKAgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:36:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41045 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZLKAgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:36:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 09:33:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 3/5] counting swap ents per mm
Message-Id: <20091211093314.c44527cd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912101153130.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210165911.97850977.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912101153130.5481@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 11:55:25 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Index: mmotm-2.6.32-Dec8/mm/rmap.c
> > ===================================================================
> > --- mmotm-2.6.32-Dec8.orig/mm/rmap.c
> > +++ mmotm-2.6.32-Dec8/mm/rmap.c
> > @@ -814,7 +814,7 @@ int try_to_unmap_one(struct page *page,
> >  	update_hiwater_rss(mm);
> >
> >  	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> > -		if (PageAnon(page))
> > +		if (PageAnon(page)) /* Not increments swapents counter */
> >  			dec_mm_counter(mm, MM_ANONPAGES);
> 
> Remove comment. Its not helping.
> 
ok.

> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Thank you,
-Kame


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbZEGCtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbZEGCtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbZEGCs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:48:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39787 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZEGCs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:48:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 4/7] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090507024656.GA12828@localhost>
References: <20090507114016.40ee6577.minchan.kim@barrios-desktop> <20090507024656.GA12828@localhost>
Message-Id: <20090507114804.2666.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  7 May 2009 11:48:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 07, 2009 at 10:40:16AM +0800, Minchan Kim wrote:
> > On Thu, 07 May 2009 09:21:21 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > +	 * pseudo flags for the well known (anonymous) memory mapped pages
> > > +	 */
> > > +	if (!PageSlab(page) && page_mapped(page))
> > > +		u |= 1 << KPF_MMAP;
> > > +	if (PageAnon(page))
> > > +		u |= 1 << KPF_ANON;
> > 
> > Why do you check PageSlab on user pages ?
> > Is there any case that PageSlab == true && page_mapped == true ?
> 
> Yes at least for SLUB: it reuses page->_mapcount, so page_mapped() is
> meaningless for slab pages.

this question and answer implies more comment required...




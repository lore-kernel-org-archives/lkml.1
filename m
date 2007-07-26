Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbXGZDUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbXGZDUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXGZDUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:20:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbXGZDUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:20:03 -0400
Date: Thu, 26 Jul 2007 12:21:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: [PATCH] config_zone_movable [1/2] clean up zone config by
 renumbering
Message-Id: <20070726122128.86db5056.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070725201016.7a8b6ec9.akpm@linux-foundation.org>
References: <20070726115020.1ff4513b.kamezawa.hiroyu@jp.fujitsu.com>
	<20070725201016.7a8b6ec9.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 20:10:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Jul 2007 11:50:20 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > I refreshed config_zone_movable patch set against 2.6.23-rc1.
> > Reflected comments on previous version.
> > Tested on ia64/NUMA system and my small i386 desktop.
> > 
> > Andrew, I like this patch but know that there are many types of memory layout. 
> > Could you test this set in -mm ?
> > I'll refresh this against rc1-mm1 if necessary.
> 
> Right now I want to concentrate on getting the present -mm queue vaguely
> stabilised, so I'd prefer to not be adding features or nontrivial cleanups
> for a few days at the minimum.
> 
ok. I'll wait.

> This process would be greatly aided by developers testing it out and
> sending fixes (or at least, reports) for anything they encounter.
>
yes. I'll test -mm.
 

> >  /*
> > + * Test zone type is configured or not.
> > + * You can use this functio for avoiding #ifdef.
> > + *
> > + * #ifdef OCNFIG_ZONE_DMA
> 
> typo there.
> 
Oooooo....I'll fix this typo when I send this again.....

Thanks,
-Kame


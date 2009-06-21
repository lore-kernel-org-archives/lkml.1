Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbZFUIsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbZFUIsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 04:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZFUIsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 04:48:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38124 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZFUIse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 04:48:34 -0400
Date: Sun, 21 Jun 2009 10:57:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, hugh.dickins@tiscali.co.uk,
       npiggin@suse.de, chris.mason@oracle.com, Rik van Riel <riel@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 11/15] HWPOISON: The high level memory error handler in the VM v8
Message-ID: <20090621085721.GD8218@one.firstfloor.org>
References: <20090620031608.624240019@intel.com> <20090620031626.106150781@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620031626.106150781@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> v8:
> check for page_mapped_in_vma() on anon pages (Hugh, Fengguang)

This change was no good as discussed earlier.

> test and use page->mapping instead of page_mapping() (Fengguang)
> cleanup some early kill comments (Fengguang)

This stuff belongs into the manpage. I haven't written it yet,
but will. I don't think kernel source comments is the right place.

> introduce invalidate_inode_page() and don't remove dirty/writeback pages
> from page cache (Nick, Fengguang)

I'm still dubious this is a good idea, it means potentially a lot 
of pages not covered.

-Andi

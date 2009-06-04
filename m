Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZFDFNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZFDFNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZFDFNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:13:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZFDFNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:13:39 -0400
Date: Thu, 4 Jun 2009 07:20:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "npiggin@suse.de" <npiggin@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [12/16] Refactor truncate to allow direct truncating of page
Message-ID: <20090604052056.GO1065@one.firstfloor.org>
References: <20090603846.816684333@firstfloor.org> <20090603184646.B915B1D0292@basil.firstfloor.org> <20090604043208.GB15682@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604043208.GB15682@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:32:08PM +0800, Wu Fengguang wrote:
> > +void truncate_inode_page(struct address_space *mapping, struct page *page)
> > +{
> > +	if (page_mapped(page)) {
> > +		unmap_mapping_range(mapping,
> > +		  (loff_t)page->index<<PAGE_CACHE_SHIFT,
> > +		  PAGE_CACHE_SIZE, 0);
> > +	}
> > +	truncate_complete_page(mapping, page);
> > +}
> > +
> 
> Small style cleanup:

Applied.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbZJOWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbZJOWI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762156AbZJOWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:08:57 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:63416 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761645AbZJOWI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:08:57 -0400
X-Trace: 271678836/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.3.134/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.3.134
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAKc510pPRQOG/2dsb2JhbACBUtdIhDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="271678836"
Date: Thu, 15 Oct 2009 23:08:19 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/9] swap_info: SWAP_HAS_CACHE cleanups
In-Reply-To: <20091015113736.d46a6a8a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0910152301550.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150150570.3291@sister.anvils>
 <20091015113736.d46a6a8a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Oct 2009 01:52:27 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > Though swap_count() is useful, I'm finding that swap_has_cache() and
> > encode_swapmap() obscure what happens in the swap_map entry, just at
> > those points where I need to understand it.  Remove them, and pass
> > more usable "usage" values to scan_swap_map(), swap_entry_free() and
> > __swap_duplicate(), instead of the SWAP_MAP and SWAP_CACHE enum.
> > 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> I have no objectios to above.

Phew!  Thanks.  I particularly had this one in mind when I Cc'ed you
on them all, because we do have a clash of styles or habits there.

My view is, the next time you or someone else is at work in there,
okay to reintroduce such things if they make it easier for you to
work on the code; but for me they made it harder.

> I'll test, later. maybe no troubles.

Thanks, yes, testing is the most important.

Hugh

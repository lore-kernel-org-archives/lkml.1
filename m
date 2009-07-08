Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZGHVaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZGHVaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZGHV37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:29:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZGHV37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:29:59 -0400
Date: Wed, 8 Jul 2009 23:29:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH] hugetlbfs: fix i_blocks accounting
Message-ID: <20090708212955.GC21449@basil.fritz.box>
References: <4A54F771.3060908@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A54F771.3060908@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> which did:
> 
> -	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
> +	inode->i_blocks -= blocks_per_huge_page(h);
>
> so just put back the freed multiplier, and it's all happy again.
Thanks looks good. Silly typo.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

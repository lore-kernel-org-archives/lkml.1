Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYHLXVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYHLXVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYHLXVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:21:25 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56098 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYHLXVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:21:24 -0400
Date: Wed, 13 Aug 2008 09:21:22 +1000
From: Simon Horman <horms@verge.net.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] IA64: make rsvd_region and num_rsvd_regions static
Message-ID: <20080812232121.GC11363@verge.net.au>
References: <20080805095739.GA12078@verge.net.au> <57C9024A16AD2D4C97DC78E552063EA30844AEFB@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA30844AEFB@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 01:47:37PM -0700, Luck, Tony wrote:
> > rsvd_region and num_rsvd_regions are only accessed in
> > arch/ia64/kernel/setup.c, so they should be static.
> 
> Are you looking at -mm or linux-next?  In my tree I see:

Whatever I was looking at, I was wrong. Sorry for the noise.

> arch/ia64/mm/contig.c:  for (i = 0; i < num_rsvd_regions; i++) {
> arch/ia64/mm/contig.c:          range_end   = min(end, rsvd_region[i].start & PAGE_MASK);
> arch/ia64/mm/contig.c:          free_start = PAGE_ALIGN(rsvd_region[i].end);

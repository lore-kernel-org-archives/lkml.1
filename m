Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZFZCBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZFZCBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZFZCA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:00:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbZFZCAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:00:55 -0400
Date: Thu, 25 Jun 2009 19:00:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Wright <chrisw@redhat.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
In-Reply-To: <20090626015205.GE28176@x200.localdomain>
Message-ID: <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com> <20090625095643F.fujita.tomonori@lab.ntt.co.jp> <20090625041605.GA9330@linux-os.sc.intel.com> <20090625134827W.fujita.tomonori@lab.ntt.co.jp> <1245913886.17089.91.camel@macbook.infradead.org>
 <1245966743.30355.42.camel@macbook.infradead.org> <20090625234342.GD28176@x200.localdomain> <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain> <20090626015205.GE28176@x200.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, Chris Wright wrote:
> I tested it on x86; works fine and creates a slightly tighter set of page
> tables (matching to e820).  But I don't have an IA-64 box w/ an IOMMU.
> 
> It does have one problem, however, the graphics work around code isn't
> compiled in on IA-64, so it needs:

Ok. Sounds like what I want is to get this patch through the ia64 people, 
after it has gotten some testing there. Since ia64 is where the current 
kernel fails anyway, that sounds like the motivation will be there too.

And there's little point in me merging it until it's been tested to fix 
the actual problem we have now.

Thanks,

		Linus

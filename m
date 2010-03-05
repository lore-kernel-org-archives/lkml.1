Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0CEErq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:47:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:60486 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab0CEErp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:47:45 -0500
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20100305012823.GD26618@linux-sh.org>
References: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com>
	 <20100304164416.GD13417@n2100.arm.linux.org.uk>
	 <1267727802.6526.545.camel@e102109-lin.cambridge.arm.com>
	 <20100304214435.GJ13417@n2100.arm.linux.org.uk>
	 <20100305012823.GD26618@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 15:46:19 +1100
Message-ID: <1267764379.22204.103.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 10:28 +0900, Paul Mundt wrote:
> In the anonymous page case, flush_anon_page() is always called prior to
> flush_dcache_page(), so flush_anon_page() could just set PG_dcache_clean
> to work around that. That would handle get_user_pages(), too. 

Well, currently, we clear PG_arch_1 in flush_dcache_page(), at least on
ppc.

Now, I have a nagging feeling that we might not need to... I'll have to
give it a closer look when I'm back from this extended week-end :-)

Cheers,
Ben.



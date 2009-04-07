Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbZDGGUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbZDGGUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDGGUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:20:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:46803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZDGGUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:20:01 -0400
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407061558.GA31261@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407053739.GA10500@elte.hu>
	 <1239083045.22733.383.camel@macbook.infradead.org>
	 <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu>
	 <1239084280.22733.404.camel@macbook.infradead.org>
	 <20090407061558.GA31261@elte.hu>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 23:18:47 -0700
Message-Id: <1239085127.22733.407.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 08:15 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > I think the problem here is actually the fact that we used 
> > 'select' instead of proper dependencies. I wouldn't normally have 
> > used the abomination that is 'select', but since I was just moving 
> > things around I ended up doing so by accident.
> 
> Yeah, it's genuinely fragile.
> 
> > X2APIC currently selects INTR_REMAP, and the bug would never have 
> > happened if we'd made X2APIC _depend_ on INTR_REMAP instead.
> >
> > This is a better fix:
> 
> Yep, that patch looks better - it gets rid of a select and 
> establishes proper dependencies - applied it to x86/urgent
> and will get it to Linus later today.

Ta.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


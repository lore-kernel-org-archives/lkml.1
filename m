Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZDKRPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZDKRPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 13:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZDKRPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 13:15:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbZDKRPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 13:15:43 -0400
Date: Sat, 11 Apr 2009 13:14:18 -0400
From: Kyle McMartin <kyle@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Kyle McMartin <kyle@redhat.com>, Matthew Garrett <mjg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu) enabled
Message-ID: <20090411171418.GB14287@kibblesnbits.boston.devel.redhat.com>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <1238003581.2085.53.camel@macbook.infradead.org> <20090325175908.GA25518@elte.hu> <1239051362.22733.87.camel@macbook.infradead.org> <20090407075640.GA16516@srcf.ucam.org> <1239429852.712.1532.camel@macbook.infradead.org> <20090411143834.GA14287@kibblesnbits.boston.devel.redhat.com> <1239468764.712.1546.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239468764.712.1546.camel@macbook.infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 09:52:39AM -0700, David Woodhouse wrote:
> > Does this include backporting the interrupt remapping fixes, or just
> > ignoring it since none of the current laptop chipsets support it?
> 
> The latter. What I've done so far is quite large for a -stable
> submission already. The interrupt remapping stuff would be even more
> intrusive, and I'm entirely unconvinced that we actually _need_ it for
> current systems.
> 
> I could make it refuse to suspend in intr_remap is enabled, I suppose --
> that would be simple enough.
>

Right, that's what I was afraid of. I think refusing to suspend is probably
a good idea. I'm probably not the only person who suspends his desktop
machines when they're not in use...

regards, Kyle

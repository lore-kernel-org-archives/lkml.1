Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYK0ULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYK0ULU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYK0ULL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:11:11 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:22950 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752588AbYK0ULK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:11:10 -0500
Date: Fri, 28 Nov 2008 05:09:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RESEND:PATCH] [ARM] clearpage: provide our own clear_user_highpage()
Message-ID: <20081127200942.GA3364@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-arch@vger.kernel.org,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org
References: <20081126171321.GA4719@dyn-67.arm.linux.org.uk> <1227719999.3387.0.camel@localhost.localdomain> <20081127102920.660303a5.sfr@canb.auug.org.au> <20081127010755.GA30854@linux-sh.org> <20081127112124.GA9233@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127112124.GA9233@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 11:21:24AM +0000, Russell King wrote:
> On Thu, Nov 27, 2008 at 10:07:55AM +0900, Paul Mundt wrote:
> > On Thu, Nov 27, 2008 at 10:29:20AM +1100, Stephen Rothwell wrote:
> > > Hi Russell,
> > > 
> > > On Wed, 26 Nov 2008 11:19:59 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > >
> > > > We'd like to pull this trick on parisc as well (another VIPT
> > > > architecture), so you can add my ack.
> > > 
> > > If this is going to be used by more than one architecture during the next
> > > merge window, then maybe the change to include/linux/highmem.h could be
> > > extracted to its own patch and sent to Linus for inclusion in 2.6.28.
> > > This way we avoid some conflicts and the architectures can do their
> > > updates independently.
> > 
> > I plan to use it on VIPT SH also, so getting the higmem.h change in by
> > itself sooner rather than later would certainly be welcome.
> 
> I'll queue the change to linux/highmem.h for when Linus gets back then.
> Can I assume that Hugh and James are happy for their ack to apply to
> both parts of the split patch?  And do I have your ack as well?
> 
Yes, my apologies for not making that obvious.

Acked-by: Paul Mundt <lethal@linux-sh.org>

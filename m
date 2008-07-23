Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYGWSkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYGWSkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYGWSkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:40:40 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46737 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbYGWSkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:40:40 -0400
Date: Wed, 23 Jul 2008 21:40:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap:
	begin the process of using proper kernel APIs
Message-ID: <20080723184022.GG14846@cs181140183.pp.htv.fi>
References: <1216325546.5515.63.camel@localhost.localdomain> <20080717202634.GI18295@redhat.com> <1216328769.5515.78.camel@localhost.localdomain> <20080717213355.GJ18295@redhat.com> <20080722140015.37628ea4@bree.surriel.com> <20080723150434.GC11191@redhat.com> <20080723082856.334f9c17__2909.60763018138$1216827051$gmane$org@infradead.org> <y0m3am0blj2.fsf@ton.toronto.redhat.com> <20080723165405.GE14846@cs181140183.pp.htv.fi> <20080723173438.GA23758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080723173438.GA23758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 01:34:38PM -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Wed, Jul 23, 2008 at 07:54:05PM +0300, Adrian Bunk wrote:
> > On Wed, Jul 23, 2008 at 12:41:37PM -0400, Frank Ch. Eigler wrote:
> > >...
> > > In the interim (before we come up with a way of moving more
> > > kernel-coupled systemtap code into kernel.org/git), would y'all
> > > consider an arrangement?  Those of you who care about systemtap, and
> > > are intending to make an incompatible kernel/module interface change,
> > > please run the systemtap testsuite before & after.  [...]
> 
> > The number of incompatible kernel/module interface changes per
> > kernel is most likely some medium three digit number.  What you have
> > in mind is therefore not really feasible.
> 
> Do you think so, even if the historical pattern continues that only a
> small fraction of those changes actually impact systemtap?

But which are these?

All commits that either remove EXPORT_SYMBOL's or touch include/ are 
candidates would have to be checked, and that's a four digit number
of commits per kernel release.

What is not feasible is to check each of thesse commits.

> > But we have several levels of kernels that incorporate future stuff,
> > from -rc over -next to -mm, and you could implement automated runs
> > of the systemtap testsuite against the latest ones.
> 
> We do some of that already and should do more.
> 
> - FChE

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


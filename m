Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZAEClj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZAEClj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZAECl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:41:27 -0500
Received: from sh.osrg.net ([192.16.179.4]:47741 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbZAECl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:41:26 -0500
Date: Mon, 5 Jan 2009 11:40:52 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org,
       jj@chaosbits.net, weiyi.huang@gmail.com, linux-kernel@vger.kernel.org,
       Ian.Campbell@citrix.com
Subject: Re: swiotlb: remove duplicated #include
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49613CC4.1000000@goop.org>
References: <20090104214109A.fujita.tomonori@lab.ntt.co.jp>
	<20090104130113.GA24506@elte.hu>
	<49613CC4.1000000@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090105114050Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2009 09:48:36 +1100
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >
> >   
> >>> In a few days, but wanted to hear back from either Jeremy or Becky 
> >>> first about how well they actually work in their usecases.
> >>>       
> >> Well, you don't need to wait, I think.
> >>
> >> All Jeremy and Becky need is adding highmem support to swiotlb. How we 
> >> support it doesn't matter. We can choose better one.
> >>
> >> We all (including Jeremy) agreed that Becky's physical address scheme is 
> >> better (simpler) than Jeremy's struct page and offset scheme. Surely, 
> >> Becky's scheme works for Xen and him (Jeremy said that he tested it 
> >> lightly).
> >>     
> >
> > Jeremy said, when he submitted this series, shortly before Christmas:
> >
> >  >> Here's a work in progress series [...]
> >  >>
> >  >> Quick testing showed no problems, but I haven't had the chance to do 
> >  >> anything extensive.
> >
> > Jeremy, did you have a chance to do more testing with the current 
> > tip/master bits on Xen, so that we can push it to Linus?
> >   
> 
> I'm going to be on vacation until the 12th, so I won't have a chance to 
> do anything until then (perhaps Ian will have a chance to poke at them 
> before then).  I'm expecting Becky's patches to work as-is, or if not, 
> be easily fixed with a couple of small bugfix patches.  So I say go 
> ahead if they work for everyone else.

Yeah, technically, Becky's scheme should work for Xen. We already
decided to go with his scheme. So it's better to push his patchset to
mainline now to make sure it doesn't break the existing swiotlb users
rather than keeping and testing the code that we will replace.

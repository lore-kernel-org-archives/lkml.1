Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZAIQhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZAIQhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZAIQhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:37:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47460 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZAIQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:37:37 -0500
X-IronPort-AV: E=Sophos;i="4.37,239,1231131600"; 
   d="scan'208";a="35145981"
Subject: Re: swiotlb: remove duplicated #include
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       beckyb@kernel.crashing.org, jj@chaosbits.net, weiyi.huang@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <49613CC4.1000000@goop.org>
References: <20090104112541.GA25434@elte.hu>
	 <20090104210420X.fujita.tomonori@lab.ntt.co.jp>
	 <20090104121914.GA30255@elte.hu>
	 <20090104214109A.fujita.tomonori@lab.ntt.co.jp>
	 <20090104130113.GA24506@elte.hu>  <49613CC4.1000000@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 09 Jan 2009 16:37:23 +0000
Message-Id: <1231519043.27350.73.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2009 16:37:29.0978 (UTC) FILETIME=[905325A0:01C97278]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 09:48 +1100, Jeremy Fitzhardinge wrote:
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

Only just got out from under my pile of vacation backlog...

They don't quite work with Xen (at least the version in Jeremy's patch
queue doesn't) but I agree that it should be possible to make it work
and that there's no point in holding back just for Xen.

Ian.

> 
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


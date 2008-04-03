Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYDCIY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYDCIY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760911AbYDCIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:24:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:16677 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbYDCIYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=D77N9RR/CqPDVHg+vdDXmJoN/JhIj+MR89LGC2E7c55+MSE7e4uxgfFcvcITK925x8O+dnwMibypZdxQV8AgIaFxxs1vaLJlRcNeCKJIac14ub70AE8Y3T8G109LlORuDXpytaUl3aS+ZKP9k6gBeVXnssEIXGfC4rXChzfBEbU=
Message-ID: <84144f020804030124m4cc0bc1en2e11218f1f8bdc55@mail.gmail.com>
Date: Thu, 3 Apr 2008 11:24:00 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc] SLQB: YASA
Cc: "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080403081338.GA18337@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403072550.GC25932@wotan.suse.de>
	 <84144f020804030045p44456894lfc006dcdeab6f67c@mail.gmail.com>
	 <20080403075725.GA7514@wotan.suse.de>
	 <20080403081338.GA18337@wotan.suse.de>
X-Google-Sender-Auth: b3f8cc41df767ad4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, Apr 03, 2008 at 09:57:25AM +0200, Nick Piggin wrote:
> > It's a completely different design of the core allocator algorithms
> > really.
> >
> > It probably looks quite similar because I started with slub.c, but
> > really is just the peripheral supporting code and structure. I'm never
> > intending to try to go through the pain of incrementally changing SLUB
> > into SLQB. If SLQB is found to be a good idea, then it could maybe get
> > merged.

On Thu, Apr 3, 2008 at 11:13 AM, Nick Piggin <npiggin@suse.de> wrote:
>  And also I guess I don't think Christoph would be very happy about
>  it :) He loves higher order allocations :)
>
>  The high level choices are pretty clear and I simply think there might
>  be a better way to do it. I'm not saying it *is* better because I simply
>  don't know, and there are areas where the tradeoffs I've made means that
>  in some situations SLQB cannot match SLUB.

So do you disagree with Christoph's statement that we should fix page
allocator performance instead of adding queues to SLUB? I also don't
think higher order allocations are the answer for regular boxes but I
can see why they're useful for HPC people with huge machines.

                                     Pekka

Return-Path: <linux-kernel-owner+w=401wt.eu-S934782AbXFFS0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782AbXFFS0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbXFFS0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:26:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:44290 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXFFS0k (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZmO/pKXoJcJI9LdOf0QevrrJ/v4jzOkEpQjt7smoxicYdzWRxET+CGl97jYXEde234HyqTxfC8lpA9jFaD/d/4Bqq53iJxk+sFMti+ueXdHND3zC8RD2nBQk/uy59jfvUtee5KOcjP1mGILfe+ky75JYmVO6J8nztsix2ZvvZk0=
Message-ID: <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com>
Date: Wed, 6 Jun 2007 11:26:38 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070606161621.GA20247@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
	 <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
	 <20070606161621.GA20247@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 06, 2007 at 09:07:16AM -0700, Jared Hulbert wrote:
> > I estimate something on the order 5-10 million Linux phones use
> > something similar to these patches.  I wonder if there are that many
> > provable users of of the simple cramfs.  This is where the community
> > has taken cramfs.
>
> This is what a community disjoint to mainline development has hacked
> cramfs in their trees into.  Not a good rationale.  This whole
> "but we've always done it" attitute is a little annoying, really.

It is that disjointedness we are trying to address.

> FYI: Cartsten had an xip fs for s390 aswell, and that evolved into
> the filemap.c bits after a lot of rework an quite a few round of
> review.

Right.  So now we leverage this filemap_xip.c in cramfs.  Why is this a problem?

> > Nevertheless, I understand your point.  I wrote AXFS in part because
> > the hacks required to do XIP on cramfs where ugly, hacky, and complex.
>
> I can't find a reference to AXFS anywhere in this thread.

No, it's not here.  There's a year old thread referencing it.

> > > Please
> > >use something like the existing ext2 xip mode instead of add support
> > >to romfs using the generic filemap methods.
> >
> > What??  You mean like use xip_file_mmap() and implement
> > get_xip_page()?  Did you read my latest patch?
>
> Yes.  This is the highlevel way to go, just please don't hack it into
> cramfs.

Right, so this latest patch _does_ implement get_xip_page() and
xip_file_mmap().  Why not hack it into cramfs?

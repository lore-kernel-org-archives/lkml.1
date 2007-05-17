Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbXEQTVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbXEQTVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbXEQTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:21:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:25975 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbXEQTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GTfiJvPE2k+Degs/nWBTGxA4pc/2SnL3pFOa8du2uJyjI5CK+ojzhte9/83ZHlAdCdRT0gf67ANOEVNdFZgU9/LigwwOu7wUalkYihk9VJxBkIhz9LNtic/4IwS+EpwZmCZZuXcrEp1Lk8DULcs0xYf6zyMKlGLwbPQhvVJy9Xo=
Message-ID: <68676e00705171220v72cf257ai80643e478c9058d3@mail.gmail.com>
Date: Thu, 17 May 2007 21:20:58 +0200
From: Luca <kronos.it@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070517174610.GA7486@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com>
	 <20070514173823.GA7137@dreamland.darkstar.lan>
	 <20070515014344.GA8850@gondor.apana.org.au>
	 <20070517174610.GA7486@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Il Tue, May 15, 2007 at 11:43:44AM +1000, Herbert Xu ha scritto:
> > On Mon, May 14, 2007 at 07:38:23PM +0200, Luca Tettamanti wrote:
> > > I'm running git 705962cc (which is a commit after -rc1) and I still see
> > > the OOPS on boot. The patch above is already applied though. Note that
> > > I'm using the SLAB allocator:
> > >
> > > CONFIG_SLAB=y
> > > # CONFIG_SLUB is not set
> > > # CONFIG_SLOB is not set
> > >
> > >
> > > Ending clean XFS mount for filesystem: dm-4
> > > BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
> >
> > Please send me your .config file.
>
> It seems that build system was confused... I've checked the timestamps
> of *.o files and make didn't rebuild anything, but rebuilding after a
> 'make clean' did "fix" the problem. Sorry for the noise...

Ok, wait: it's still there. It's just not 100% reproducible, sometimes
the system boots fine. So it either crashes on boot or it runs fine
for hours.

Luca

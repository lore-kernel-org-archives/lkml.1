Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXJYQx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXJYQx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXJYQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:53:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35404 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166AbXJYQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:53:16 -0400
Date: Thu, 25 Oct 2007 18:53:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jie Zhang <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Message-ID: <20071025165344.GL30533@stusta.de>
References: <20071024162643.GP30533@stusta.de> <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com> <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com> <47200826.1060801@zytor.com> <20071025150545.GK30533@stusta.de> <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 12:16:40PM -0400, Mike Frysinger wrote:
> On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> > On Wed, Oct 24, 2007 at 08:06:14PM -0700, H. Peter Anvin wrote:
> > > Mike Frysinger wrote:
> > >> we'll have to either use the gcc attributes to force old inline
> > >> behavior or use the gcc flag to force it
> > >
> > > We should probably have an extern_inline define then, assuming this is a
> > > function that does exist in a linkable version already -- otherwise "static
> > > inline" is correct.
> >
> > Since we #define inline to be __attribute__((always_inline))
> > "extern inline" with the old semantics would only behave differently
> > if someone took the address of one of these string functions.
> 
> that isnt what we intended ;)
> 
> > Does this happen anywhere in the blackfin port?
> 
> gcc is also free to ignore the optimized inline in favor of an
> external reference

It is not since we #define inline to be __attribute__((always_inline)).

> -mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


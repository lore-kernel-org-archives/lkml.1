Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbYBHUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbYBHUEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbYBHUER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:04:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:64283 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbYBHUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LUQEcy7hYpxw+CJD12LSqrHvyY7MnXwEZPOVAoTWFbineEoM2NijMu3EZ+z3rSriXB8jTl7TEMvXvunP6NKIVJcqeoURQwhX5zd2FSBM9go20ydhJgFy1nc4D3NPF4Qh5l7f9W4+VlViSnP0xytqMbWIJVgEz2rOn4tGxoIkrXI=
Message-ID: <8bd0f97a0802081204x202eec8bn1ab83d529b9f8c7b@mail.gmail.com>
Date: Fri, 8 Feb 2008 15:04:09 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: blackfin compile error
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Matt Mackall" <mpm@selenic.com>, "Adrian Bunk" <bunk@kernel.org>,
       bryan.wu@analog.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>
In-Reply-To: <386072610802081053r73aeb264m7f86d513ec7d1c6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
	 <1202315015.17934.242.camel@cinder.waste.org>
	 <200802061412.50675.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0802072125l16e3fc5cw91a92eed299f82e8@mail.gmail.com>
	 <386072610802081053r73aeb264m7f86d513ec7d1c6d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 1:53 PM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> On Feb 8, 2008 1:25 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> > looks like only MMU code currently uses the function, but to keep
> > things nice, we may want something like:
> > static inline int is_swap_pte(pte_t pte)
> > {
> > #ifdef CONFIG_MMU
> >     return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
> > #else
> >     return 0;
> > #endif
> > }
> >
> > the header is also lacking an #include <asm/pgtable.h> at the top ...
>
> Did you submit a patch to mainline? It should be merged to fix this
> compiling error.

posted
-mike

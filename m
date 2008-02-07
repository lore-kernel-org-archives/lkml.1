Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbYBGH0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbYBGH0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbYBGH0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:26:23 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:11807 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbYBGH0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:26:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZAKujfW1yMmSY1eb2oGkCe9N5vqXIbmedYtZ7fAliHSr0Mlh24utYi9kkcc1gZAl08wx47Ze4sRQ2qse5I/2vXXHTiH239mptlGlnzTAtsBfRT1uYr/hGJm09dbEkrDVbUKKkKk9PtJeRKRd+4ZQNQMbSF/cKaZOkw/54g5EwRE=
Message-ID: <386072610802062326h4e41a351h28f1d93906784ed0@mail.gmail.com>
Date: Thu, 7 Feb 2008 15:26:20 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: blackfin compile error
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, mpm@selenic.com,
       bunk@kernel.org, bryan.wu@analog.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
In-Reply-To: <20080206113734.511473b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
	 <1202315015.17934.242.camel@cinder.waste.org>
	 <200802061412.50675.rgetz@blackfin.uclinux.org>
	 <20080206113734.511473b0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 3:37 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 6 Feb 2008 14:12:50 -0500
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
>
> > On Wed 6 Feb 2008 11:23, Matt Mackall pondered:
> > >
> > > On Wed, 2008-02-06 at 17:18 +0200, Adrian Bunk wrote:
> > > > Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:
> > > >
> > > > <--  snip  -->
> > > >
> > > > ...
> > > >   CC      mm/vmscan.o
> > > > In file included from
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
> > > > make[2]: *** [mm/vmscan.o] Error 1
> > >
> > > This suggests that no one's tried to compile -mm on Blackfin since
> > > before September, I think.
> >
> > Or any other nommu arch's either, since looking at the include files, FRV
> > (when configured as noMMU) and m68knommu does not include it either...
>
> sh is the only nommu arch which I test-compile for.
>
> The world would be a better place if arch maintainers (or their helpers)
> were to build and test -mm once a month or so.
>

I will be here for Blackfin. Actually, we got some patches in -mm, it
is necessary to built and test -mm on Blackfin.

Thanks
-Bryan

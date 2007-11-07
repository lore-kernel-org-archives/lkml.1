Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbXKGSnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbXKGSnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXKGSnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:43:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:55477 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbXKGSnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:43:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,385,1188802800"; 
   d="scan'208";a="313801894"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: x86_64 ten times slower than i386
Date: Wed, 7 Nov 2007 11:38:25 -0700
User-Agent: KMail/1.9.7
Cc: Ray Lee <ray-lk@madrabbit.org>,
       Bo =?iso-8859-1?q?Brant=E9n?= <bosse@acc.umu.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <2c0942db0711050832t5207ea8bib1f75e59e071ade2@mail.gmail.com> <20071106002647.GA27182@one.firstfloor.org>
In-Reply-To: <20071106002647.GA27182@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711071038.26263.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2007 4:26 Andi Kleen wrote:
> On Mon, Nov 05, 2007 at 08:32:24AM -0800, Ray Lee wrote:
> > (Don't trim cc:s.)
> >
> > On Nov 5, 2007 8:00 AM, Bo Brantén <bosse@acc.umu.se> wrote:
> > >> Intel Core 2 Quad
> > >> and I noticed that the 64-bit versions was at least 10 times
> > >> slower than the 32-bit versions,
> > >
> > > After I uppgraded the BIOS the mtrr looks like below, and now it
> > > works if I boot with mem=4736M so I can use all memory but it
> > > still doesn't work without the mem parameter then it will run as
> > > slow as before.
>
> Then the BIOS is still broken Comapl in to your motherboard vendor.
>
> > > reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> > > reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> > > reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> > > reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> > > reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
> > > reg05: base=0x100000000 (4096MB), size= 512MB: write-back,
> > > count=1 reg06: base=0x120000000 (4608MB), size= 128MB:
> > > write-back, count=1
> >
> > Jesse Barnes (cc:d) wrote a patch to address this, I think (x86:
> > trim memory not covered by WB MTRRs), but as far as I can tell it
> > hasn't been merged yet. System is Intel, 4gb of RAM.
>
> It wasn't merged because it broke booting on some systems.
> Besides the memory would be still lost -- all it did was to automate
> the "mem=XXXX" line.

Andi, do you have any details on which system broke and how?  I haven't 
heard back from you on my last message on the subject... the patch was 
in -mm for awhile with no complaints.

Ultimately, this is a broken BIOS issue, but still, it would be nice if 
the kernel handled it better.

Thanks,
Jesse

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbZLOUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbZLOUJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZLOUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:09:21 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57103 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZLOUJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:09:20 -0500
Date: Tue, 15 Dec 2009 21:09:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215200918.GX28252@kernel.dk>
References: <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org> <20091215194319.GT28252@kernel.dk> <4B27E817.6030705@kernel.org> <20091215195111.GV28252@kernel.dk> <4B27E9FD.5080306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27E9FD.5080306@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15 2009, Yinghai Lu wrote:
> Jens Axboe wrote:
> > On Tue, Dec 15 2009, Yinghai Lu wrote:
> >> Jens Axboe wrote:
> >>> On Tue, Dec 15 2009, Yinghai Lu wrote:
> >>>> [PATCH] x86/pci: intel ioh bus num reg accessing fix
> >>>>
> >>>> it is above 0x100, so if mmconf is not enable, need to skip it
> >>> This works, it kexecs kernels fine. But since 2.6.32 doesn't have the
> >>> mmconf problem to begin with, are we now just working around the issue?
> >>> SRAT still reports issues, numa doesn't work.
> >> that patch will be bullet proof... we need it.
> >>
> >> also still need to figure out why memmap range is not passed properly.
> >>
> >> do you mean 2.6.32 kexec 2.6.32 it have worked mmconf and numa in
> >> second kernel?
> > 
> > Yes, 2.6.32 booted and 2.6.32 kexec'ed works just fine, no SRAT
> > complaints and NUMA works fine.
> > 
> how about
> 
> current kernel booted and 2.6.32 kexec'ed works just fine, no SRAT
> complaints and NUMA works fine. ?

Yes, that's exactly what happens, see the previous reply I sent. mmconf
still complains, though.

-- 
Jens Axboe


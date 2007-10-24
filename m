Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXJXDFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXJXDFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXJXDFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:05:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:8756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbXJXDFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,322,1188802800"; 
   d="scan'208";a="304335907"
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <471E89E1.7060903@zytor.com>
References: <1193126771.23935.79.camel@caritas-dev.intel.com>
	 <471E70E0.2090802@goop.org> <200710240118.21160.ak@suse.de>
	 <471E89E1.7060903@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Oct 2007 11:08:18 +0800
Message-Id: <1193195298.23935.125.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 24 Oct 2007 03:05:34.0283 (UTC) FILETIME=[BE82C1B0:01C815EA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 16:55 -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> > With the early reserve code in 
> > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> > and
> > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc
> > this could be likely done cleaner.
> > 
> 
> Indeed it could.  For i386, the equivalent code would have another 
> significant benefit: reserving memory and then mapping and accessing it 
> later would (at least eventually) allow accesses > 4 GB on PAE kernels 
> (or with a PSE36 hack, on non-PAE kernels.)

For i386, the bootmem allocator covers at most 0~796M memory area. So
some early reserve memory area can not be revered with bootmem allocator
later. Should we fix bootmem allocator firstly?

Best Regards,
Huang Ying

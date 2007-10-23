Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbXJWXzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbXJWXzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXJWXzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:55:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbXJWXzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:55:31 -0400
Message-ID: <471E89E1.7060903@zytor.com>
Date: Tue, 23 Oct 2007 16:55:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org> <200710240118.21160.ak@suse.de>
In-Reply-To: <200710240118.21160.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> With the early reserve code in 
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> and
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc
> this could be likely done cleaner.
> 

Indeed it could.  For i386, the equivalent code would have another 
significant benefit: reserving memory and then mapping and accessing it 
later would (at least eventually) allow accesses > 4 GB on PAE kernels 
(or with a PSE36 hack, on non-PAE kernels.)

	-hpa

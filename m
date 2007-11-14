Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbXKNC2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbXKNC2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXKNC2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:28:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41960 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbXKNC2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:28:34 -0500
Date: Wed, 14 Nov 2007 03:28:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, clameter@sgi.com, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
Message-ID: <20071114022832.GC20365@one.firstfloor.org>
References: <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net> <p73wssly6sr.fsf@bingen.suse.de> <20071113.175208.168903694.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113.175208.168903694.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 05:52:08PM -0800, David Miller wrote:
> Yes, I've run into similar problems with lockdep as well.
> I had to build an ultra minimalized kernel to get it to
> boot on my Niagara boxes.
> 
> I think I even looked at the same lockdep code, and I'd
> appreciate it if you'd submit your fix for this if you
> haven't already.

ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc 
ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/lockdep-early-alloc

I didn't plan to submit it for .24, just .25. Or do you need it 
urgently?

Also it would require you to write a sparc specific arch_early_alloc()
of course.  I've only done the x86-64 version.

-Andi

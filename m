Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbXKNDtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbXKNDtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbXKNDtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:49:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58883 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757029AbXKNDtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:49:06 -0500
Date: Tue, 13 Nov 2007 19:49:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071114022832.GC20365@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0711131948200.7348@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net>
 <p73wssly6sr.fsf@bingen.suse.de> <20071113.175208.168903694.davem@davemloft.net>
 <20071114022832.GC20365@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Andi Kleen wrote:

> On Tue, Nov 13, 2007 at 05:52:08PM -0800, David Miller wrote:
> > Yes, I've run into similar problems with lockdep as well.
> > I had to build an ultra minimalized kernel to get it to
> > boot on my Niagara boxes.
> > 
> > I think I even looked at the same lockdep code, and I'd
> > appreciate it if you'd submit your fix for this if you
> > haven't already.
> 
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-reserve
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/early-alloc 
> ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/lockdep-early-alloc
> 
> I didn't plan to submit it for .24, just .25. Or do you need it 
> urgently?
> 
> Also it would require you to write a sparc specific arch_early_alloc()
> of course.  I've only done the x86-64 version.

IA64 also has no lockdep. What arches support lockdep?


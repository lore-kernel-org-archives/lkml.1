Return-Path: <linux-kernel-owner+w=401wt.eu-S1423020AbXBBFWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423020AbXBBFWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423098AbXBBFWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:22:55 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:45721 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423020AbXBBFWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:22:54 -0500
Date: Thu, 1 Feb 2007 21:22:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
In-Reply-To: <20070129160921.7b362c8d.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0702012121020.10723@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070126030753.03529e7a.akpm@osdl.org> <Pine.LNX.4.64.0701260751230.6141@schroedinger.engr.sgi.com>
 <20070126114615.5aa9e213.akpm@osdl.org> <Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
 <20070126122747.dde74c97.akpm@osdl.org> <Pine.LNX.4.64.0701291349450.548@schroedinger.engr.sgi.com>
 <20070129143654.27fcd4a4.akpm@osdl.org> <Pine.LNX.4.64.0701291441260.1102@schroedinger.engr.sgi.com>
 <20070129225000.GG6602@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0701291533500.1169@schroedinger.engr.sgi.com>
 <20070129160921.7b362c8d.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Andrew Morton wrote:

> On Mon, 29 Jan 2007 15:37:29 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > With a alloc_pages_range() one would be able to specify upper and lower 
> > boundaries.
> 
> Is there a proposal anywhere regarding how this would be implemented?

Yes it was discussed a while back in August. Look for alloc_pages_range. 
Sadly I have not been able to do work on it since there are too many 
other issues.


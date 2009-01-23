Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZAWQAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZAWQAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZAWQAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:00:38 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:44681 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbZAWQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:00:37 -0500
Date: Fri, 23 Jan 2009 10:57:10 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <200901240237.10522.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0901231055520.32253@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240212.58829.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901231025320.21692@qirst.com> <200901240237.10522.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Nick Piggin wrote:

> However, I don't know if netperf udp 4K over loopback is totally
> realistic. Maybe real network drivers have different allocation patterns.
> If I were you I wouldn't be too hasty to make big changes based on that
> alone, if it could introduce regression in somewhere more important.

AFAICT it just wastes memory. My idea of a slab allocator is that it is
used for small (less than page sized) allocations. The page allocator
should be able to handle page sized allocations in an effective manner.


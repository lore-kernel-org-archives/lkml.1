Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbXKHUV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbXKHUV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761075AbXKHUVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:21:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45864 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761320AbXKHUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:21:16 -0500
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711081048490.7871@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com>
	 <20071106195157.878563669@sgi.com> <1194525257.6289.145.camel@twins>
	 <Pine.LNX.4.64.0711081031420.7871@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0711081048490.7871@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 21:19:34 +0100
Message-Id: <1194553174.20832.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-08 at 10:50 -0800, Christoph Lameter wrote:
> On Thu, 8 Nov 2007, Christoph Lameter wrote:
> 
> > > Also, looking at the lock usage, this thing is not IRQ safe, so it
> > > should not be called from hardirq context. Please document this.
> 
> Well I went the other way and made it work like the slab allocators.

Nice.


Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbXGWVng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbXGWVng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXGWVn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:43:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36714 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756918AbXGWVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:43:25 -0400
Date: Mon, 23 Jul 2007 14:43:23 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
Message-ID: <20070723144323.1ac34b16@schroedinger.engr.sgi.com>
In-Reply-To: <1185216048.5535.1.camel@lappy>
References: <1185185020.8197.11.camel@twins>
	<20070723113712.c0ee29e5.akpm@linux-foundation.org>
	<1185216048.5535.1.camel@lappy>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_ZERO is implemented by the slab allocators (the page allocator
has no knowledge about the length of the object to be zeroed). The slab
allocators do not pass __GFP_ZERO to the page allocator.



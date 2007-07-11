Return-Path: <linux-kernel-owner+w=401wt.eu-S1765984AbXGKSZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765984AbXGKSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbXGKSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:25:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33796 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbXGKSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:25:29 -0400
Date: Wed, 11 Jul 2007 21:25:28 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <Pine.LNX.4.64.0707111104370.14730@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0707112121130.17548@sbz-30.cs.Helsinki.FI>
References: <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
 <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
 <20070710083212.GG11115@waste.org> <Pine.LNX.4.64.0707101836280.7011@schroedinger.engr.sgi.com>
 <20070711020646.GZ11115@waste.org> <Pine.LNX.4.64.0707111104370.14730@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, 11 Jul 2007, Christoph Lameter wrote:
> Of course you are the maintainer but you only authored a single patch 
> which was the original submission in all the time that SLOB was in the 
> tree. I keep having to clean up the allocator that has--according to 
> Pekka--more memory requirements than SLUB. There is no point in keeping it 
> around anymore it seems.

Well, it was a test setup with UML and busybox and didn't have all the 
SLOB optimizations Nick mentioned, so we shouldn't draw any definite 
conclusions from it. I couldn't get 2.6.22-rc6-mm1 to compile so I'll try 
again after Andrew pushes a new release out.

Furthermore, as much as I would like to see SLOB nuked too, we can't do 
that until Matt and Nick are satisfied with SLUB for small devices and 
what I can gather, they aren't.

			Pekka

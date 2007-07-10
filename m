Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbXGJM5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbXGJM5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXGJM52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:57:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXGJM51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:57:27 -0400
Date: Tue, 10 Jul 2007 15:57:26 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <20070710120224.GP11115@waste.org>
Message-ID: <Pine.LNX.4.64.0707101544150.27425@sbz-30.cs.Helsinki.FI>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
 <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI> <469342DC.8070007@yahoo.com.au>
 <84144f020707100231p5013e1aer767562c26fc52eeb@mail.gmail.com>
 <20070710120224.GP11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Tue, 10 Jul 2007, Matt Mackall wrote:
> Using 2.6.22-rc6-mm1 with a 64MB lguest and busybox, I'm seeing the
> following as the best MemFree numbers after several boots each:
> 
> SLAB: 54796
> SLOB: 55044
> SLUB: 53944
> SLUB: 54788 (debug turned off)
> 
> These numbers bounce around a lot more from boot to boot than I
> remember, so take these numbers with a grain of salt.

To rule out userland, 2.6.22 with 32 MB defconfig UML and busybox [1] on 
i386:

SLOB: 26708
SLUB: 27212 (no debug)

Unfortunately UML is broken in 2.6.22-rc6-mm1, so I don't know if SLOB 
patches help there.

  1. http://uml.nagafix.co.uk/BusyBox-1.5.0/BusyBox-1.5.0-x86-root_fs.bz2

			Pekka

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbXGJCLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbXGJCLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbXGJCLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:11:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59115 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755496AbXGJCLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:11:05 -0400
Date: Mon, 9 Jul 2007 19:11:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <4692E8B5.3030404@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
 <4692E8B5.3030404@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Nick Piggin wrote:

> It is reasonable to expect some help from maintainers, but I notice you
> didn't even CC the SLOB maintainer in the patch to remove SLOB! So maybe
> if you tried working a bit closer with him you could get better results?

The maintainers last patch to SLOB was the initial submission of the 
allocator. Then he acked subsequent patches. Most of the modifications to 
SLOB are my work. Attempts to talk to the maintainer result in inventive 
explanations why SLOB does not have to conform to kernel standards. There 
is no reasonable expectation that this will change.

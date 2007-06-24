Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbXFXKZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbXFXKZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 06:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXFXKZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 06:25:01 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:40499 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbXFXKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 06:25:00 -0400
Date: Sun, 24 Jun 2007 11:24:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <20070624083849.GA19079@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJtaytsa21sQGFybS5saW51eC5vcmcudWsA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Russell King wrote:
> On Fri, Jun 22, 2007 at 07:39:33PM +0100, Hugh Dickins wrote:
> > I'm quite happy with this approach for 2.6.23-rc, along with your ARM
> > dma_map patch which (if I understood aright) rmk approved.
> 
> I didn't approve it.  Please re-read my reply - there are still some
> unanswered questions in it which _really_ need answering.

Sorry for misrepresenting you.

> The report talks about the AT91 machines.  These machines do not have
> cache coherent DMA.  Therefore, the code being patched should be
> optimised away by the compiler. *Or* we have even bigger problems.
> 
> Please forward the original problem report.

Done.
Hugh

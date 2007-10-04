Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbXJDRkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbXJDRkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXJDRkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:40:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42387 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756659AbXJDRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:40:41 -0400
Date: Thu, 4 Oct 2007 10:40:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [13/18] x86_64: Allow fallback for the stack
In-Reply-To: <200710041425.43343.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0710041039000.10854@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <200710041356.51750.ak@suse.de>
 <1191499692.22357.4.camel@twins> <200710041425.43343.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Andi Kleen wrote:

> > The order-1 allocation failures where GFP_ATOMIC, because SLUB uses !0
> > order for everything.
> 
> slub is wrong then. Can it be fixed?

SLUB in mm kernels was using higher order allocations for some slabs 
for the last 6 months or so. Not true for upstream.


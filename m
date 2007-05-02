Return-Path: <linux-kernel-owner+w=401wt.eu-S1767256AbXEBTBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767256AbXEBTBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767255AbXEBTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:01:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49442 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767256AbXEBTBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:01:22 -0400
Date: Wed, 2 May 2007 12:01:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, haveblue@ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070502115725.683ac702.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705021158150.1220@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021924200.24456@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021137210.1027@schroedinger.engr.sgi.com>
 <20070502115725.683ac702.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Andrew Morton wrote:

> noooo, we don't want competing slab allocators, please.  We should get slub
> working well on all architectures then remove slab completely.  Having to
> maintain both slab.c and slub.c would be awful.

Owww... You throw my roadmap out of the window and may create too 
high expectations of SLUB.

I am the one who has to maintain SLAB and SLUB it seems and I have been 
dealing with the trio SLAB, SLOB and SLUB for awhile now. Its okay and it 
will be much easier once the cleanups are in.

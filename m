Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYFKXWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYFKXWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYFKXWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:22:39 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44933 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753779AbYFKXWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:22:39 -0400
Date: Wed, 11 Jun 2008 16:22:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
In-Reply-To: <20080611073330.GB30983@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0806111622130.23868@schroedinger.engr.sgi.com>
References: <20080602072706.GB28268@linux-sh.org>
 <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
 <20080611073330.GB30983@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Paul Mundt wrote:

> Thanks for the review. Using virt_addr_valid() we can also get rid of
> blackfin's idiotic > memory_end test for its DMA addresses, as the same
> logic is encapsulated there. How does this look?

Reviewed-by: Christoph Lameter <clameter@sgi.com>

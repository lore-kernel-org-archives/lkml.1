Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbXJ2XZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbXJ2XZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXJ2XZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:25:39 -0400
Received: from waste.org ([66.93.16.53]:59745 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbXJ2XZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:25:38 -0400
Date: Mon, 29 Oct 2007 18:25:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 02/10] SLUB: Noinline some functions to avoid them being folded into alloc/free
Message-ID: <20071029232515.GR17536@waste.org>
References: <20071028033156.022983073@sgi.com> <20071028033258.779134394@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028033258.779134394@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 08:31:58PM -0700, Christoph Lameter wrote:
> Some function tend to get folded into __slab_free and __slab_alloc
> although they are rarely called. They cause register pressure that
> leads to bad code generation.

Nice - an example of uninlining to directly improve performance!

-- 
Mathematics is the supreme nostalgia of our time.

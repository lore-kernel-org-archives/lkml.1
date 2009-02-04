Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZBDUPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZBDUPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbZBDUPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:15:34 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:44449 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759477AbZBDUPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:15:32 -0500
Date: Wed, 4 Feb 2009 15:10:31 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902041509320.8154@qirst.com>
References: <20090114155923.GC1616@wotan.suse.de>  <20090123155307.GB14517@wotan.suse.de>  <alpine.DEB.1.10.0901261225240.1908@qirst.com>  <200902031253.28078.nickpiggin@yahoo.com.au>  <alpine.DEB.1.10.0902031217390.17910@qirst.com>
 <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Pekka Enberg wrote:

> Well, the slab_hiwater() check in __slab_free() of mm/slqb.c will cap
> the size of the queue. But we do the same thing in SLAB with
> alien->limit in cache_free_alien() and ac->limit in __cache_free(). So
> I'm not sure what you mean when you say that the queues will "grow
> unconstrained" (in either of the allocators). Hmm?

Nick said he wanted to defer queue processing. If the water marks are
checked and queue processing run then of course queue processing is not
deferred and the queue does not build up further.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbXHONV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbXHONV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbXHONVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:21:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbXHONV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:21:29 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
References: <20070814142103.204771292@sgi.com>
	<20070815122253.GA15268@wotan.suse.de>
	<1187183526.6114.45.camel@twins>
From: Andi Kleen <andi@firstfloor.org>
Date: 15 Aug 2007 16:15:35 +0200
In-Reply-To: <1187183526.6114.45.camel@twins>
Message-ID: <p731we43muw.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> Christoph's suggestion to set min_free_kbytes to 20% is ridiculous - nor
> does it solve all deadlocks :-(

A minimum enforced reclaimable non dirty threshold wouldn't be
that ridiculous though. So the memory could be used, just not
for dirty data.

His patchkit essentially turns the GFP_ATOMIC requirements 
from free to easily reclaimable. I see that as an general improvement.

I remember sct talked about this many years ago and it's still
a good idea.

-Andi

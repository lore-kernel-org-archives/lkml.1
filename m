Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZI1Typ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZI1Typ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZI1Typ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:54:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZI1Tyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:54:44 -0400
Date: Mon, 28 Sep 2009 21:54:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928195444.GF1656@one.firstfloor.org>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org> <20090928012337.GC1656@one.firstfloor.org> <20090928104617.9c4b868a.akpm@linux-foundation.org> <20090928200317.64a419ff@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928200317.64a419ff@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw just to add to this:
> caches are unified code/data after L1 in general... it then does not
> matter much if you encode the "almost constant" in the codestream or
> slightly farther away, in both cases it takes up cache space.

It does take up cache space, but when it's embedded in the instruction
stream the CPU has it usually already prefetched (CPUs are very good
at prefetching instructions). That's often not the case
with arbitary data accesses like this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

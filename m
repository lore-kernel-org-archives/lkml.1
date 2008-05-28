Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYE1SlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYE1SlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYE1Sky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:40:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbYE1Skx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:40:53 -0400
Date: Wed, 28 May 2008 20:40:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Fede <fedux@lugmen.org.ar>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jan Engelhardt <jengelh@medozas.de>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Re: bad pmd ffff810000207238(9090909090909090).
Message-ID: <20080528184006.GA14585@elte.hu>
References: <483CBCDD.10401@lugmen.org.ar> <Pine.LNX.4.64.0805281922530.7959@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805281922530.7959@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> [PATCH] x86: fix bad pmd ffff810000207xxx(9090909090909090)
> 
> OGAWA Hirofumi and Fede have reported rare pmd_ERROR messages: 
> mm/memory.c:127: bad pmd ffff810000207xxx(9090909090909090).
> 
> Initialization's cleanup_highmap was leaving alignment filler behind 
> in the pmd for MODULES_VADDR: when vmalloc's guard page would occupy a 
> new page table, it's not allocated, and then module unload's vfree 
> hits the bad 9090 pmd entry left over.

applied, nice catch!

	Ingo

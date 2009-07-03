Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZGCSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZGCSZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZGCSZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:25:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZGCSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:25:42 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
	<tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org>
	<4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu>
	<20090703111033.6e9627de@infradead.org>
	<20090703181815.GC3405@elte.hu>
Date: Fri, 03 Jul 2009 20:25:45 +0200
In-Reply-To: <20090703181815.GC3405@elte.hu> (Ingo Molnar's message of "Fri, 3 Jul 2009 20:18:15 +0200")
Message-ID: <87k52paaja.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> Is the same true of XADD as well? If yes then we can remove the lock 
> prefix from those as well - there's a few uses of that on 32-bit and 
> 64-bit as well.

XADD also has no implicit LOCK. AFAIK the implicit semantics are 
only true for XCHG.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

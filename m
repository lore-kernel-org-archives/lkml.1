Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZBBJwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZBBJwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZBBJw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:52:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:60213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZBBJw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:52:28 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
References: <20090130230936.GA7549@elte.hu>
	 <1233421901.4787.27.camel@laptop> <1233422632.4787.31.camel@laptop>
	 <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 10:52:13 +0100
Message-Id: <1233568333.4787.110.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 20:49 +0300, Alexey Zaytsev wrote:
> And answering an earlier question, this happens only on i386 and only
> with 4K stacks because x86_64 dosn't have a separate softirq stack,
> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.

Which suggests that an initial preempt_count offset of 1 should suffice
to fix this issue and not confuse the softirq tracing, hmm?


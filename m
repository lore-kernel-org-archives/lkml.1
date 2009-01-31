Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZAaSJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZAaSJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZAaSIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:08:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:55853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZAaSIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:08:54 -0500
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
Date: Sat, 31 Jan 2009 19:08:47 +0100
Message-Id: <1233425327.4787.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 20:49 +0300, Alexey Zaytsev wrote:
> 
> And answering an earlier question, this happens only on i386 and only
> with 4K stacks because x86_64 dosn't have a separate softirq stack,
> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.

What do the other 30 odd architectures that Linux supports do? Is i386
4k really the _only_ with separate softirq stacks?


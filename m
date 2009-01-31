Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZAaVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZAaVV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZAaVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:21:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54679 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335AbZAaVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:21:19 -0500
Date: Sat, 31 Jan 2009 21:21:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090131212106.6e2e05b0@lxorguk.ukuu.org.uk>
In-Reply-To: <1233425327.4787.35.camel@laptop>
References: <20090130230936.GA7549@elte.hu>
	<1233421901.4787.27.camel@laptop>
	<1233422632.4787.31.camel@laptop>
	<f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
	<1233425327.4787.35.camel@laptop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 19:08:47 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-01-31 at 20:49 +0300, Alexey Zaytsev wrote:
> > 
> > And answering an earlier question, this happens only on i386 and only
> > with 4K stacks because x86_64 dosn't have a separate softirq stack,
> > so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
> 
> What do the other 30 odd architectures that Linux supports do? Is i386
> 4k really the _only_ with separate softirq stacks?

x86-64 and some of the other platforms could do with IRQ stacks but that
is another story.

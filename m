Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbZBDW2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbZBDW2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZBDW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:28:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:51282 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbZBDW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T0ILuuLWR93khayIiKG8C4ESFCYCKXToWrCkQv+UWdmE39StfNP9qZiiLH9O9KiPVw
         vIG/Dx0pl/E1lvm9eTw0ObnTBzcEQiQ8YnGD+Vbj2DoGcC9OIpigbZ1PvuN6igej+JCU
         GN3f9GddY9Pi++QUovp3vcepoJEgHeoxmlPBg=
MIME-Version: 1.0
In-Reply-To: <1233568333.4787.110.camel@laptop>
References: <20090130230936.GA7549@elte.hu> <1233421901.4787.27.camel@laptop>
	 <1233422632.4787.31.camel@laptop>
	 <f19298770901310949m7aabf7bcp219ae4cc5d1b363b@mail.gmail.com>
	 <1233568333.4787.110.camel@laptop>
Date: Thu, 5 Feb 2009 01:28:37 +0300
Message-ID: <f19298770902041428m6a23846fud8cfba8bb3deab4@mail.gmail.com>
Subject: Re: [git pull] scheduler fixes
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 12:52, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2009-01-31 at 20:49 +0300, Alexey Zaytsev wrote:
>> And answering an earlier question, this happens only on i386 and only
>> with 4K stacks because x86_64 dosn't have a separate softirq stack,
>> so the preempt count diring the soft irq is at least IRQ_EXIT_OFFSET.
>
> Which suggests that an initial preempt_count offset of 1 should suffice
> to fix this issue and not confuse the softirq tracing, hmm?

Can't we just copy the preempt count when switching stacks?

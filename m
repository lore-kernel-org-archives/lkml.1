Return-Path: <linux-kernel-owner+w=401wt.eu-S937230AbXGSNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937230AbXGSNka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbXGSNkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:40:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51368 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbXGSNkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:40:11 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrea Arcangeli <andrea@suse.de>,
       Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 19 Jul 2007 15:37:54 +0200
References: <8Hgoq-7Cd-21@gated-at.bofh.it> <8Hz7K-38K-37@gated-at.bofh.it> <8HHeZ-7R1-21@gated-at.bofh.it> <8HHoA-835-21@gated-at.bofh.it> <8HHI2-8r2-27@gated-at.bofh.it> <8HHRD-rK-19@gated-at.bofh.it> <8HI1j-Dn-21@gated-at.bofh.it> <8HIb2-PD-5@gated-at.bofh.it> <8IrUr-4SZ-9@gated-at.bofh.it> <8IsdO-5g4-7@gated-at.bofh.it> <8It9R-6Eb-3@gated-at.bofh.it> <8IAkZ-WW-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IBWCZ-0000j2-3W@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+Bd3Nbdpy5EPHj2AFEJDzUQVRCb8p/HoNHkjG
 HhpAPX64jRH34ZJbGecnE/z/LRX643DPDlr1CJWe37P4cMAw3r
 RIShzIFHba//iF0w5OFoQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 19 Jul 2007 03:33:58 +0200
> Andrea Arcangeli <andrea@suse.de> wrote:

>> > 8K stacks without IRQ stacks are not "safer" so I don't understand your
>> > comment ?
>> 
>> Ouch, see the reports about 4k stack crashes. I agree they're not
>> safe w/o irq stacks (like on x86-64), but they're generally safer.
> 
> Still don't follow. How is "exceeds stack space but less likely to be
> noticed" safer.

If there is a tree in the forest, is it as likely to fall as the three
that's being chopped in front of our eyes? It is, because each tree will
fall eventually, but you'd still not allow your kids to play on the
tree being chopped, but you'd probably allow them to climb that other tree
like all the other kids do.

The same applies to the stack: We don't know if or when we'll see all
possible interrupts fire and kill the 8K stack, but we know for sure the
8K stack has been climbed for years and there is an axe on that 4K stack.
So where do you send the users to play?
-- 
What's worse than a Male Chauvinist Pig?
A woman that won't do what she's told.

Friﬂ, Spammer: Fq@Bbu29.7eggert.dyndns.org od1Gkubx@hrBky.7eggert.dyndns.org

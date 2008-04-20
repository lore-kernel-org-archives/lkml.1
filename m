Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYDTUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYDTUYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYDTUYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:24:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:50941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbYDTUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:24:13 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: x86: 4kstacks default
To: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Reply-To: 7eggert@gmx.de
Date: Sun, 20 Apr 2008 22:23:45 +0200
References: <ak6tq-32p-7@gated-at.bofh.it> <akFri-4yB-25@gated-at.bofh.it> <akGQg-7TX-1@gated-at.bofh.it> <akKhi-91-37@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Jng4g-0003WM-Bu@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/j9m1H3EJHOK0pI0BFV5dnoE8oO/qu6Iclrsu
 ze4uKd0grlpQSNZCqXnC0xUaW4BSpn9bqRf/BHcwIUaObW7oz2
 vgjUOxHAbA5+ke4rNI79w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> wrote:
> On Sunday 20 April 2008 08:27:14 Andi Kleen wrote:
>> Adrian Bunk <bunk@kernel.org> writes:
>> > 6k is known to work, and there aren't many problems known with 4k.
>> >
>> > And from a QA point of view the only way of getting 4k thoroughly tested
>>
>> But you have to first ask why do you want 4k tested? Does it serve
>> any useful purpose in itself? I don't think so. Or you're saying
>> it's important to support 50k kernel threads on 32bit kernels?

> Andi, you're the only one I've seen seriously pounding the "50k threads"
> thing - I don't think anyone is really fooled by the straw-man, so I'd
> suggest you drop it.
> 
> The real issue is that you think (and are correct in thinking) that people are
> idiots. Yes, there will be breakages if the default is changed to 4k stacks -
> but if people are running new kernels on boxes that'll hit stack use problems
> (that *AREN'T* related to ndiswrapper) and haven't made sure that they've
> configured the kernel properly, then they deserve the outcome. It isn't the
> job of the Linux Kernel to protect the incompetent - nor is it the job of
> linux kernel developers to do such.

It's the job of the kernel developers to mark experimental and broken options,
and to put a warning:

"This will break stacking of drivers, especially if disk manager, xfs, RAID
and nfs are used. Yes, linux is broken by default, but only if you intend to
set up a reliable system, so this will be OK!"

into the help text, instead of expecting each admin to read lkml.


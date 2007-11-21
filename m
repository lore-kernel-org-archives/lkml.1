Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbXKUAIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbXKUAIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXKUAH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:07:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXKUAH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:07:58 -0500
Date: Wed, 21 Nov 2007 01:07:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Lord <lkml@rtr.ca>, Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071121000742.GN23667@elte.hu>
References: <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca> <20071120232723.GB23667@elte.hu> <47436ECD.3050004@zytor.com> <20071120234725.GH23667@elte.hu> <474372BC.2000609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474372BC.2000609@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>>> Nope.  It runs inside an initramfs, of course; that initramfs is 
>>> linked into the kernel binary.
>>
>> would be nice to have a single-image variant for all of this. having 
>> the separate initrd was always trouble - and it's pointless as well. 
>> (we rarely update the initrd without updating the vmlinuz as well)
>
> We do.  Am I missing something?

do we have a single-image way of getting both the kernel image and the 
initram set up at once? What i know of is a two-image approach: vmlinuz 
and initrd.

	Ingo

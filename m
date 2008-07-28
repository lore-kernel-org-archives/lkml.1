Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYG1Q2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYG1Q2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbYG1Q2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:28:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbYG1Q2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:28:37 -0400
Date: Mon, 28 Jul 2008 18:28:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <jbeulich@novell.com>, Joerg Roedel <joro@8bytes.org>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve double fault handling
Message-ID: <20080728162816.GB27662@elte.hu>
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu> <4885CEFE.76E4.0078.0@novell.com> <20080728134252.GI5515@elte.hu> <488DECD9.76E4.0078.0@novell.com> <488DD176.50600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488DD176.50600@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Jan Beulich wrote:
>>
>>> Firstly, 64-bit does not use a task gate for double faults anymore. 
>>> (but uses a separate IST stack for double faults)
>>
>> Sure - because there are no task gates on 64-bit.
>>
>
> What we're doing here is really using task gates to emulate IST 
> anyway.

yes, because we dont use the main feature that differentiates task gates 
from ISTs: a different cr3 entry. (the rest of the differences is really 
just fluff)

	Ingo

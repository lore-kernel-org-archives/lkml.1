Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZDTAkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZDTAkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDTAj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:39:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZDTAj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:39:58 -0400
Date: Mon, 20 Apr 2009 02:38:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
Message-ID: <20090420003857.GA10438@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <20090414165722.GD2089@elte.hu> <20090414180832.GA25692@elte.hu> <49E79B1E.9090405@garzik.org> <20090419233518.GA765@elte.hu> <49EBB9D0.6060307@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EBB9D0.6060307@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

>> Regarding the new x86/Voyager submission: architecture or core 
>> kernel level code always has a higher barrier of entry than 
>> driver code for a number of good reasons:
>
> No, my point is that it is blatantly unfair to remove code, then 
> reset standards for inclusion far, far higher than at which it 
> left the tree.

Oh, i'm all for including new code optimistically. (in fact i'm 
probably a bit over-inclusive)

But i'm not at all for easily re-including known problematic code 
that has been removed. Including known problematic code under the 
same standard as removal i'd call 'very stupid'.

IMO it is a fundamentally good engineering practice to learn from 
past experience and to learn from past mistakes and to require a 
higher standard if an old standard failed to produce an acceptable 
result first time around.

_Especially_ so for such an extremely obsolete piece of hardware 
with a single upstream user+developer and a dismal upstream track 
record ... We really have to learn to say 'no' at a certain point
...

I dont care about Voyager that much - but i do care about not doing 
stupid things intentionally in the code i (co-)maintain.

Anyway, as i said it in the previous mail - in the end it's up to 
Linus and he can override our NAK if we are wrong about it.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZBNHgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZBNHgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 02:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZBNHgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 02:36:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZBNHgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 02:36:22 -0500
Date: Sat, 14 Feb 2009 08:36:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/headers] x86: fix "__udivdi3"
	[drivers/scsi/aha1542.ko] undefined
Message-ID: <20090214073606.GB10863@elte.hu>
References: <tip-bf33a70a73876b163d62612e9567cbac6604ba7e@kernel.org> <4995D4A9.5060400@zytor.com> <1234560979.3252.22.camel@localhost.localdomain> <4995F979.9040304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4995F979.9040304@zytor.com>
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

> James Bottomley wrote:
>> On Fri, 2009-02-13 at 12:14 -0800, H. Peter Anvin wrote:
>>> James Bottomley wrote:
>>>
>>> #define isa_virt_to_bus(x) ((unsigned int)virt_to_phys(x))
>>>
>>> ... if we're going to do that.
>>
>> Actually, it probably wants to become a static inline ... that way the
>> compiler can always verify the promotion and truncation is legal
>> regardless of whether an actual user is compiled or not.
>>
>
> Yes, that's the right thing to do.  I'll fix it up and commit a patch.

Yeah, sure - nevertheless i committed the obvious build fix first.

And as i said, the whole pointer magic construct in aha1542 is a borderline
bug, and if anything like that pops up in non-utter-legacy code it should
be cleaned up anyway.

	Ingo

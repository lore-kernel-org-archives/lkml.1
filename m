Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYLAKtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYLAKtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYLAKti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:49:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYLAKti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:49:38 -0500
Date: Mon, 1 Dec 2008 11:49:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest@ozlabs.org,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, jeremy@xensource.com,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch
	changes
Message-ID: <20081201104904.GA12859@elte.hu>
References: <20081104150729.GC21470@localhost> <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com> <200812011502.37170.rusty@rustcorp.com.au> <4933AD51.5000202@redhat.com> <aa79d98a0812010232s4a2f13f9v2a34c4368047d000@mail.gmail.com> <4933BF71.6010801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4933BF71.6010801@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> Cyrill Gorcunov wrote:
>> On Mon, Dec 1, 2008 at 12:24 PM, Avi Kivity <avi@redhat.com> wrote:
>> ...
>>   
>>> Once it's done there's no reason not to commit it.  But the effort expended
>>> to do it is gone, without any measurable return.
>>>
>>>     
>> ...
>>
>> Not sure Avi what you mean but as far as I know Alexander is working on
>> this file so he need just time to finish (we all have other duties you know :).
>> So I think the idea Peter proposed could be merged right after Alexander
>> will have finished. At least the Peter's suggestion was recorded in this
>> thread which means it will *not* be lost eventually. Or you meant something
>> else (yep, I could have it translated plain wrong)?
>>   
>
> What I mean is that hpa's patch makes the kernel better, so it should 
> be applied.  I'm not sure what else Alexander is working on, but I do 
> hope the improvements will be more concrete.

that is what happened three weeks ago already on Nov 11, we applied
Peter's patches to tip/x86/irq:

   939b787: x86: 64 bits: shrink and align IRQ stubs
   b7c6244: x86: 32 bits: shrink and align IRQ stubs

it's all in the x86 tree and in linux-next as well. Alexander and Peter 
are working on this together, not against each other. Alexander was still 
running some numbers to make sure we made the right decision.

	Ingo

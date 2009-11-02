Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZKBK3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZKBK3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZKBK3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:29:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264AbZKBK3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:29:20 -0500
Date: Mon, 2 Nov 2009 11:28:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: percpu/kvm/tip tree build failure
Message-ID: <20091102102830.GA3724@elte.hu>
References: <20091102161722.eea4358d.sfr@canb.auug.org.au> <4AEEAA82.8070705@redhat.com> <20091102100735.GB16963@elte.hu> <4AEEB0AF.5000904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEEB0AF.5000904@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Avi Kivity <avi@redhat.com> wrote:

> On 11/02/2009 12:07 PM, Ingo Molnar wrote:
>>> Ingo, can you queue this on x86/entry?
>>>      
>> Already done, tested and pushed out.
>
> Usually there is an ack from tip-bot?

Yeah, the final, committed form of the patch (with small edits done in 
99% of the cases) gets sent to the discussion thread on lkml and can be 
reviewed (and double checked) there.

<plug> We use the tip-bot mechanism to:

 - increase transparency (every commit gets posted into the lkml thread 
   it originates from),

 - avoid patch-bombing/spamming lkml every week/month with new patches,

 - it also makes the patch postings much more on-topic and easier to
   ignore for those who are not interested in a discussion,

 - it can also be used to fine-tune any workflow details - the specific
   timings can be seen in the discussion, missed or incorrectly queued 
   patches can be identified,

 - new discussions/bugreports can be started based on that commit
   notification, on lkml.

Developers and maintainers involved in the process absolutely love it as 
it visibly increases workflow reliability and transparency and increases 
the information density on lkml - you might want to consider something 
similar too, for kvm.git ;-)

</plug>

Should be in your mbox any minute.

	Ingo

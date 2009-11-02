Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZKBKIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZKBKIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZKBKIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:08:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbZKBKIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:08:34 -0500
Date: Mon, 2 Nov 2009 11:07:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: percpu/kvm/tip tree build failure
Message-ID: <20091102100735.GB16963@elte.hu>
References: <20091102161722.eea4358d.sfr@canb.auug.org.au> <4AEEAA82.8070705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEEAA82.8070705@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 11/02/2009 07:17 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next build (x86_64 allmodconfig) failed like this:
>>
>> kernel/user-return-notifier.c: In function 'fire_user_return_notifiers':
>> kernel/user-return-notifier.c:45: error: expected expression before ')' token
>>
>> Introduced by commit 7c68af6e32c73992bad24107311f3433c89016e2 ("core,
>> x86: Add user return notifiers") from the tip and kvm trees but revealed
>> by commit e0fdb0e050eae331046385643618f12452aa7e73 ("percpu: add __percpu
>> for sparse") from the percpu tree.  Before that percpu tree commit,
>> "put_cpu_var()" would compile without error (even though it really needs
>> a parameter).
>>
>> I have applied the following patch for today.
>>    
>
> Ingo, can you queue this on x86/entry?

Already done, tested and pushed out.

	Ingo

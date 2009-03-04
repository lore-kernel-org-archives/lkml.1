Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZCDAvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZCDAvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZCDAu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:50:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZCDAu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:50:57 -0500
Date: Wed, 4 Mar 2009 01:50:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu  chunk
	allocation
Message-ID: <20090304005036.GD11782@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224141217.GA17287@elte.hu> <49A40624.4000100@kernel.org> <200903041033.09502.rusty@rustcorp.com.au> <49ADC80F.6010200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ADC80F.6010200@zytor.com>
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

> Rusty Russell wrote:
>> On Wednesday 25 February 2009 01:07:24 Tejun Heo wrote:
>>> it always
>>> saves a 2MB TLB entry for all the non-NUMA machines out there.
>>
>> Note that everyone keeps talking about "a" TLB entry; I wanted to make
>> sure (esp. for those of us reading from the sidelines), it's not: it's
>> up to num_possible_cpus() TLB entries.  Of course, many paths won't access
>> other CPU's data, but it'd be interesting (and pretty easy) to actually
>> instrument how rare this is...
>>
>
> Actually it's up to the number of actual CPUs in the system... 
> obviously there isn't any data allocated for non-present CPUs.

well, we allocate percpu data for each possible CPU.

In the overwhelming majority of cases that means all actual 
CPUs.

	Ingo

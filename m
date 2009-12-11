Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZLKDSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZLKDSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZLKDSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:18:04 -0500
Received: from mail.lang.hm ([64.81.33.126]:60873 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbZLKDSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:18:04 -0500
Date: Thu, 10 Dec 2009 19:16:35 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
In-Reply-To: <20091125074033.4c46c1b0@infradead.org>
Message-ID: <alpine.DEB.2.00.0912101915430.10307@asgard.lang.hm>
References: <20091120211139.GB19106@sgi.com> <m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com> <alpine.LFD.2.00.0911241246470.24119@localhost.localdomain> <1259069986.4531.1453.camel@laptop> <alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
 <20091124065022.6933be1a@infradead.org> <m1ws1f6csh.fsf@fess.ebiederm.org> <20091125074033.4c46c1b0@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Arjan van de Ven wrote:

>> I think the irq scheduler is the only scheduler (except for batch
>> jobs) that we don't put in the kernel.  It seems to me that if we are
>> going to go to all of the trouble to rewrite the generic code to
>> better support irqbalance because we are having serious irqbalance
>> problems, it will be less effort to suck irqbalance into the kernel
>> along with everything else.
>
> we had that; it didn't work.
> what I'm asking for is for the kernel to expose the numa information;
> right now that is the piece that is missing.

but if there is only one userspace app, and that app has no user 
accessable configuration, what is the difference between telling everyone 
they must use that app and having the logic from that app in the kernel?

David Lang

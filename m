Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbZBSMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbZBSMWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZBSMWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:22:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZBSMWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:22:03 -0500
Date: Thu, 19 Feb 2009 13:21:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Message-ID: <20090219122112.GD1703@elte.hu>
References: <20090216163847.431174825@chello.nl> <1234859071.4744.10.camel@laptop> <20090217094359.GA1231@elte.hu> <200902181520.17504.rusty@rustcorp.com.au> <20090218160535.GD23989@elte.hu> <499CA106.8020104@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499CA106.8020104@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> The kmalloc(GFP_ATOMIC) has been in kernel/smp.c for about half a year, 
>> since:
>>
>>  |  commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
>>  |  Author: Jens Axboe <jens.axboe@oracle.com>
>>  |  Date:   Thu Jun 26 11:21:34 2008 +0200
>>  |  Subject: [PATCH] Add generic helpers for arch IPI function calls
>>
>> Which introduced kernel/smp.c to begin with. It got merged on July 15.
>>   
>
> The kmalloc to resolve the stack lifetime vs rcu bug is more 
> recent than that - around August, I think.

yeah, it was in a late -rc, and solved rare crashes that you 
reported.

	Ingo

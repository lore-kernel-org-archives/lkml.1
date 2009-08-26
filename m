Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZHZWKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZHZWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZHZWKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:10:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZHZWKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:10:51 -0400
Date: Thu, 27 Aug 2009 00:10:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove lockdep annotations from RCU's
	_notrace() API members
Message-ID: <20090826221034.GA31586@elte.hu>
References: <20090826015337.GA18904@linux.vnet.ibm.com> <tip-06e799764eb7c2e4640888d438c3524d756613e1@git.kernel.org> <20090826084938.GA5023@elte.hu> <20090826173318.GC6752@linux.vnet.ibm.com> <20090826183954.GE13632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826183954.GE13632@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> and booted it - and that did not produce any lockups. So you might 
> not be able to reproduce it :-/ I've re-merged core/rcu into 
> tip/master, maybe my tests can find another config that reproduces 
> the crash better. Please disregard this bugreport until i've found 
> that one.

it's in iteration #300 now and still no crash - so i think we can 
disregard this. This means the lockup got fixed for good :)

	Ingo

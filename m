Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbXJLIgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbXJLIgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 04:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXJLIgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 04:36:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbXJLIgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 04:36:01 -0400
Date: Fri, 12 Oct 2007 10:35:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rok Markovic <kernel@kanardia.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
Message-ID: <20071012083551.GA17937@elte.hu>
References: <470F27DA.9020307@kanardia.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470F27DA.9020307@kanardia.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_20,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1875]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


does anything get printed prior the lockup if you enable all of these:

# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_FRAME_POINTER is not set

?

	Ingo

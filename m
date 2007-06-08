Return-Path: <linux-kernel-owner+w=401wt.eu-S966990AbXFHA32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966990AbXFHA32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933876AbXFHA3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:29:20 -0400
Received: from www.osadl.org ([213.239.205.134]:53125 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933871AbXFHA3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:29:19 -0400
Message-Id: <20070607235106.387346000@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:29:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Stable Team <stable@kernel.org>
Subject: [patch 0/4] PI-Futex bugfixes and cleanups
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

the following patch series solves the issues with pi-futexes which
were reported from Alexey.

While the first three patches should go mainline ASAP, the last patch
is not necessarily 2.6.22 material. I did this cleanup to make the
code more readable again.

@stable: 
The rtmutex patches (1,2) should apply to stable as is, but
the futex patch will not. I'm going to backport the fixes tomorrow and
send a seperate series with all fixes.

Pending problems:

There are also the pending REQUEUE_PI issues. I have seen some
problems there, but I did not address them in this patch set. I have
no test program to verify any changes in that code.

I'm not sure, whether we should keep the REQUEUE_PI stuff for
2.6.22. I'd prefer to back it out or at least disable it, so we can
fix it proper for 2.6.23.

	tglx
	
Sorry for the resend. My mailer did not notice the CC wreckage

-- 


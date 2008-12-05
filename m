Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYLEIpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYLEIpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYLEIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:44:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLEIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:44:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=iyh7Hm7ZNXnnt5apEAXicsCR7ZgCqYgZFzw0aFTSxC9JIEA2U4wHRxFgzbLJVK/yZ
	F3OLK4PXm3TBlhMhhXNDg==
MIME-Version: 1.0
In-Reply-To: <1228463394.18899.17.camel@twins>
References: <b040c32a0812042337r7bf6282apd53e3412458d415b@mail.gmail.com>
	 <1228463394.18899.17.camel@twins>
Date: Fri, 5 Dec 2008 00:44:52 -0800
Message-ID: <b040c32a0812050044g309eafb7h5b2eb29d9d8840c2@mail.gmail.com>
Subject: Re: [patch] make wake-affine a sysctl variable
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 11:49 PM, Peter Zijlstra wrote:
> This patch looks like utter rubbish, sorry.

Yeah, I think turning off wake-affine completely is a lot cleaner and
is a preferred solution.  I proposed sysctl variable earlier so that
it can give people a knob to adjust and is more flexible.

diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index da5d93b..c712958 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -2,7 +2,7 @@ SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
 SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
-SCHED_FEAT(AFFINE_WAKEUPS, 1)
+SCHED_FEAT(AFFINE_WAKEUPS, 0)
 SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 0)

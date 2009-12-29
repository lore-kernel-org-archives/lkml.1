Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZL2KtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZL2KtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 05:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZL2KtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 05:49:16 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44534 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbZL2KtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 05:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=mkWMLpyrWYqb9t5ykrx0GKGK41b48uNwTGJe1BUZaG4R8eVNOrUWncSYTLm6YvMJKS
         oKSp6cDzmnzNGCQeFqNiZneH/c3Gmd34t95HjaVQzKJP+WatgQ2zgrqDxORQEWpc0Wjg
         HT+OZIHVRVjtOQMpfq5QtiPYsQ8NCZdTmNd6Q=
MIME-Version: 1.0
Date: Tue, 29 Dec 2009 11:49:14 +0100
Message-ID: <c76f371a0912290249u5bbeee4ckadfc94f5d2df4d8e@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
From: Stijn Devriendt <highguy@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 'inject' event is a very useful feature and it's suggested by Ingo
> [ See http://lkml.org/lkml/2009/12/28/31 ]

Is it possible to, instead of injecting a specific inject_event enum,
pass a type/config pair (+task/cpu?) to inject the value of that
specific event? Then the HZ could have it's own perf_event type.

This integrates better with what I'm struggling with right now:
counters that are not ever incrementing but rather indicate
a discrete value inside the kernel that might change both
up and down. My dynticks knowledge is rather limited but
if HZ might vary then this approach is definately worth it.

Regards,
Stijn

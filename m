Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbXJCO4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbXJCO4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXJCO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:56:33 -0400
Received: from [122.1.235.145] ([122.1.235.145]:55978 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXJCO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:56:32 -0400
To: yoshfuji@linux-ipv6.org, a.p.zijlstra@chello.nl
Cc: kaigai@kaigai.gr.jp, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
	<1191420442.5599.12.camel@lappy>
	<200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
	<20071003.233249.126777093.yoshfuji@linux-ipv6.org>
In-Reply-To: <20071003.233249.126777093.yoshfuji@linux-ipv6.org>
Message-Id: <200710032356.JIH05236.JQSMOOHFLVFFOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 23:56:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.


YOSHIFUJI Hideaki wrote:
> It is not a good practice.  Please free such objects.
> BTW, how many objects do you have in the list?
It varies from 0 to some thousands,
depending on the policy supplied by the administrator and/or the policy appended by "learning mode".


Peter Zijlstra wrote:
> sounds like a might fine memory leak / dos attack.
TOMOYO Linux keeps the policy in CD-R's manner.
Thus, once an entry is written, it's pointer is valid forever.
TOMOYO Linux's simplicity (singly-linked list with no read_lock) comes from
this "keep the policy in CD-R's manner".
Yes, it is a kind of memory leak, but is controllable.

The kernel no longer requires memory after entering into "enforcing mode".
So, attackers can't do DoS attack after entering into "enforcing mode".


Regards.


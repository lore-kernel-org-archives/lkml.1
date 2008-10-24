Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbYJXK1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbYJXK1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYJXK1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:27:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYJXK1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:27:04 -0400
Date: Fri, 24 Oct 2008 12:26:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, vatsa@in.ibm.com
Subject: Re: [PATCH 0/8] scheduler patches
Message-ID: <20081024102655.GA1738@elte.hu>
References: <20081024090611.936552213@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024090611.936552213@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 1-3 definite 28 patches
> 4-5 wanna-be 28 patches

ok, applied them to tip/sched/urgent, thanks Peter!

> 6-8 29 work

Could we have a #9 that uses a no-fastpath-overhead min() method instead 
of avg_vruntime? Maybe we can get away without that overhead?

	Ingo

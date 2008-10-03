Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYJCJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYJCJmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYJCJmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:42:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbYJCJmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:42:02 -0400
Date: Fri, 3 Oct 2008 11:41:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] Trivial fix: correct a format to avoid a warning
Message-ID: <20081003094155.GA19260@elte.hu>
References: <48E5E862.1070504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48E5E862.1070504@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Last -tip gives this warning:
> 
> kernel/softirq.c: Dans la fonction «__do_softirq» :
> kernel/softirq.c:216: attention : format «%ld» expects type «long int», but argument 2 has type «int»
> 
> This patch corrects the format type, and a small mistake in the "softirq" word.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/core/softirq, thanks Frederic!

	Ingo

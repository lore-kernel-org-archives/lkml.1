Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYHKTZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYHKTZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYHKTZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:25:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41451 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbYHKTZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:25:44 -0400
Date: Mon, 11 Aug 2008 21:25:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Oruba <peter.oruba@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via
	workqueue.
Message-ID: <20080811192517.GF12788@elte.hu>
References: <20080806152117.198754464@amd.com> <20080806152319.773811325@amd.com> <20080806084446.68683aaf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806084446.68683aaf@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Wed, 6 Aug 2008 17:21:20 +0200
> Peter Oruba <peter.oruba@amd.com> wrote:
> 
> [ no description or reason ]
> 
> Why is this?
> 
> I'm not very happy about this.. it means practically that this stuff 
> *has* to run late. Probably later than we want to. (Like.. we may want 
> to redo the microcode during resume.. which is not a schedulable 
> context)

also, with the hotplug notifier call sequence fixed/changed now, there's 
no pressing reason to do this change.

	Ingo

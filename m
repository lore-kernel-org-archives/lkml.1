Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbYHOWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbYHOWyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHOWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:54:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbYHOWyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:54:08 -0400
Date: Sat, 16 Aug 2008 00:53:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080815225356.GA25538@elte.hu>
References: <20080815152938.4bc9d48c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815152938.4bc9d48c@infradead.org>
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

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] debug: add notifier chain debugging
> 
> during some development we suspected a case where we left something in 
> a notifier chain that was from a module that was unloaded already... 
> and that sort of thing is rather hard to track down.
> 
> This patch adds a very simple sanity check (which isn't all that 
> expensive) to make sure the notifier we're about to call is actually 
> from either the kernel itself of from a still-loaded module, avoiding 
> a hard-to-chase-down crash.

applied for testing, thanks Arjan.

	Ingo

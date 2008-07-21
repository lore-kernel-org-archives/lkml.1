Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYGULY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYGULY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYGULYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:24:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYGULYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:24:18 -0400
Date: Mon, 21 Jul 2008 13:23:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-kernel: fix sparse warnings
Message-ID: <20080721112355.GA23095@elte.hu>
References: <1215879607.19076.36.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1215879607.19076.36.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> ﻿I am trying to solve following sparse warnings. Please give me feedback
> for the Patch. You can also find updated sparse patches from
> http://git.infradead.org/users/jaswinder/sparse-2.6.git

>  28 files changed, 140 insertions(+), 18 deletions(-)

nice.

Could you please split this up into individual commits, and against 
tip/master:

  http://people.redhat.com/mingo/tip.git/README

Granularity should be roughly per file. (i.e. around 30 commits would be 
fine) That way if any commit is found to be bad we can unapply/revert it 
just fine without the rest of your changes. Merging into different topic 
branches is also easier that way.

	Ingo

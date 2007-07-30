Return-Path: <linux-kernel-owner+w=401wt.eu-S939115AbXG3Jaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939115AbXG3Jaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935674AbXG3JaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:30:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36284 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935419AbXG3JaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:30:24 -0400
Date: Mon, 30 Jul 2007 11:30:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 5/9] net: fix mis-merge in qdisc_restart
Message-ID: <20070730093013.GE25640@elte.hu>
References: <20070730024534.369897977@mvista.com> <20070730024720.116454959@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024720.116454959@mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> This mismerge caused my networking to malfunction. The interface would 
> come up, but no traffic would make it in/out ..

your patch only affects the !CONFIG_PREEMPT_RT case, so with that 
qualification indeed that happened, and i've applied your fix.

	Ingo

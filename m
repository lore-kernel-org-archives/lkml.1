Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYGWJgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYGWJgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYGWJgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:36:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYGWJgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:36:16 -0400
Date: Wed, 23 Jul 2008 11:36:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [lockdep warning] INFO: inconsistent lock state,
	serial8250_interrupt(), &port_lock_key
Message-ID: <20080723093604.GA29817@elte.hu>
References: <20080723093332.GA22109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723093332.GA22109@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0328]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> =================================
> [ INFO: inconsistent lock state ]
> 2.6.26-tip-06509-gb4ebc67-dirty #13600
> ---------------------------------

the upstream component of that is: v2.6.26-6077-gc010b2f

i.e. my suspicion is that this got introduced via the recent tty 
changes.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbXLQN1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbXLQN1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbXLQN04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:26:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbXLQN0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:26:55 -0500
Date: Mon, 17 Dec 2007 14:26:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: honor notify_die() returning NOTIFY_STOP
Message-ID: <20071217132638.GC1870@elte.hu>
References: <47610870.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47610870.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jan Beulich <jbeulich@novell.com> wrote:

> This requires making die() return a value, making its callers honor 
> this (and be prepared that it may return), and making oops_end() have 
> two additional parameters.

thanks, applied your patch to x86.git - queued it up for v2.6.25.

	Ingo

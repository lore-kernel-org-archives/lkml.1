Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbYCFNNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbYCFNNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYCFNNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:13:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbYCFNNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:13:47 -0500
Date: Thu, 6 Mar 2008 14:13:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
Message-ID: <20080306131323.GD21359@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com> <20080305134150.GA16477@elte.hu> <20080306075223.BA28B2700FD@magilla.localdomain> <20080306113413.GD17906@elte.hu> <20080306121648.A53FA2700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306121648.A53FA2700FD@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > So in theory the bug should manifest itself as block-step mode never 
> > clearing itself, once activated.
> 
> That doesn't happen in the trivial sense of "never", because in the 
> normal case an actual block-step exception happens and that makes the 
> hardware clear BTF from the MSR (as well as TF from eflags).  So it 
> would only come up in a more obscure case. [...]

ah, i missed that detail - this indeed makes this code a lot less 
dangerous.

/me stops worrying

	Ingo

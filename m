Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbYCENm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbYCENm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYCENmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:42:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYCENmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:42:16 -0500
Date: Wed, 5 Mar 2008 14:41:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>, Roland McGrath <roland@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
Message-ID: <20080305134150.GA16477@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CE69B0.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> TIF_DEBUGCTLMSR has no meaning in the actual MSR...

thanks, applied. The effect of this bug is that block-stepping is not 
disabled ... [~TIF_DEBUGCTLMSR masks out bit 25, while in the MSR we 
want to mask out bit 1]

Roland - i guess this means block-stepping (a new ptrace feature in .25) 
is not particularly well-tested. Do you have any standalone testcases 
that could be run?

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYDUP4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYDUP4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbYDUPzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:55:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbYDUPzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:55:52 -0400
Date: Mon, 21 Apr 2008 17:55:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jan Beulich <jbeulich@novell.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
Message-ID: <20080421155534.GA1284@elte.hu>
References: <20080418194334.7483627037C@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418194334.7483627037C@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1177]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> If TIF_DEBUGCTLMSR is ever set on a machine without the support, that 
> is a bug we should diagnose earlier.  If you want some paranoia, then 
> keep update_debugctlmsr but make it do:
> 
> 	BUG_ON(boot_cpu_data.x86 < 6);
> 
> instead.

agreed. Jan, wanna send a fix for this?

	Ingo

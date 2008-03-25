Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYCYJAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYCYJAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 05:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYCYJAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 05:00:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbYCYJAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:00:44 -0400
Date: Tue, 25 Mar 2008 10:00:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/148] include/asm-x86: checkpatch cleanups -
	formatting only
Message-ID: <20080325090022.GB813@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0057]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> Ingo's code-quality script totals for include/asm-x86
> 
>          Errors      LOC
> Before:    1457    31320
> After:      252    31729
> 
> Changes:

btw., i'd prefer to see more structural cleanups as well. For example, 
to convert macros that generate code (i.e. just about everything except 
constants) to inlines. For example in include/asm-x86/processor.h, to 
convert get_debugreg/set_debugreg or task_pt_regs to inline functions.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYACJi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYACJi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYACJit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:38:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55243 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbYACJis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:38:48 -0500
Date: Thu, 3 Jan 2008 10:38:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: qbarnes <qbarnes@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use is_kprobe_fault to better match usage
Message-ID: <20080103093837.GA18355@elte.hu>
References: <1199322323.6323.76.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199322323.6323.76.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Currently the notify_page_fault helper is used to test it the page 
> fault was caused by a kprobe causing an early return from 
> do_page_fault.
> 
> Change the name of the helper to is_kprobe_fault to match the usage 
> and remove the preempt_disable/enable pair around kprobe_running() 
> with an explicit test for preemption.  The idea for this comes from a 
> patch by Quentin Barnes to kprobes.c
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

hm, this doesnt apply:

 Hunk #3 FAILED at 426.
 Hunk #4 succeeded at 413 (offset -22 lines).
 1 out of 4 hunks FAILED -- rejects in file arch/x86/mm/fault_32.c
 patching file arch/x86/mm/fault_64.c
 Hunk #3 FAILED at 476.
 Hunk #4 succeeded at 475 (offset -10 lines).
 1 out of 4 hunks FAILED -- rejects in file arch/x86/mm/fault_64.c

could you double-check x86.git#mm, perhaps we are out of sync with a 
patch somewhere?

	Ingo

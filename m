Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZJLUmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZJLUmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZJLUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:42:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbZJLUml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:42:41 -0400
Date: Mon, 12 Oct 2009 22:41:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: ashwinc@codeaurora.org
Cc: mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC] [PATCH 1/1] Remove static debugfs path from parse-events
Message-ID: <20091012204143.GB17163@elte.hu>
References: <a751bdc6978478de6d10440e587a2cc7.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a751bdc6978478de6d10440e587a2cc7.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* ashwinc@codeaurora.org <ashwinc@codeaurora.org> wrote:

> I was working on getting timechart running and noticed that it 
> wouldn't get any sched_switch/wakeup etc events if debugfs is mounted 
> anywhere other than /sys/kernel/debug/. Mine was mounted in /debug 
> (the second sane location ;) )

It's the first sane location ;-)

> So we'd need something like whats in the patch to make use of the 
> global debugfs_path.

Applied, thanks Ashwin!

	Ingo

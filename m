Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYFBKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYFBKvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYFBKv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:51:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbYFBKv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:51:26 -0400
Date: Mon, 2 Jun 2008 12:51:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: user update and disable dynamic ftrace daemon
Message-ID: <20080602105114.GE898@elte.hu>
References: <Pine.LNX.4.58.0805272047500.13881@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805272047500.13881@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch adds a new file /debugfs/tracing/ftraced_enabled. If the 
> daemon is active, reading this will return "enabled\n" and 
> "disabled\n" when the daemon is not running. To disable the daemon, 
> the user can echo "0" or "disable" into this file, and "1" or "enable" 
> to re-enable the daemon.

applied to tip/tracing/ftrace. Thanks,

	Ingo

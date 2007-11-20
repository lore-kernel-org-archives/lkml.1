Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXKTUiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXKTUiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbXKTUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:37:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760537AbXKTUhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:37:52 -0500
Date: Tue, 20 Nov 2007 21:37:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Remy Bohmer <linux@bohmer.net>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Message-ID: <20071120203730.GA10008@elte.hu>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com> <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com> <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com> <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com> <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com> <1195316550.25393.21.camel@imap.mvista.com> <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com> <1195320569.25393.38.camel@imap.mvista.com> <20071117174608.GA30641@elte.hu> <1195576996.16514.4.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195576996.16514.4.camel@imap.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Sat, 2007-11-17 at 18:46 +0100, Ingo Molnar wrote:
> 
> > fixing the top 20:
> 
> There are about 25 DECLARE_MUTEX() semaphores remaining .. One is the 
> BKL which I would guess can't be converted. The others I've looked at 
> appear to be trivial find/replace changes to get them to use the mutex 
> type.. Any reason those haven't been converted over?

i guess talking about it instead of posting patches is a factor ;-)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763727AbXKQSRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763727AbXKQSRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbXKQSRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:17:15 -0500
Received: from homer.mvista.com ([63.81.120.158]:4604 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbXKQSRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:17:14 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Remy Bohmer <linux@bohmer.net>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071117180430.GA10768@elte.hu>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu>
	 <1195322141.25393.41.camel@imap.mvista.com>
	 <20071117180430.GA10768@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Nov 2007 10:12:57 -0800
Message-Id: <1195323177.25393.56.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-11-17 at 19:04 +0100, Ingo Molnar wrote:

> 
> split the list with you? Feel free to take any of those :-) dev->sem is 
> nontrivial and probably not possible right now - and some of the others 
> might be problematic too. But there might be fixable ones in the list. 
> This shouldnt become like the BKL conversion - never truly finished.

If I said I was going to do some set, at least it's more likely that the
work isn't duplicated..

What specifically is wrong with dev->sem ?

Daniel


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764465AbXKTU7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764465AbXKTU7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbXKTU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:59:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45150 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760974AbXKTU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:59:21 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Remy Bohmer <linux@bohmer.net>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071120203730.GA10008@elte.hu>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu> <1195576996.16514.4.camel@imap.mvista.com>
	 <20071120203730.GA10008@elte.hu>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 12:54:10 -0800
Message-Id: <1195592050.16514.14.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 21:37 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Sat, 2007-11-17 at 18:46 +0100, Ingo Molnar wrote:
> > 
> > > fixing the top 20:
> > 
> > There are about 25 DECLARE_MUTEX() semaphores remaining .. One is the 
> > BKL which I would guess can't be converted. The others I've looked at 
> > appear to be trivial find/replace changes to get them to use the mutex 
> > type.. Any reason those haven't been converted over?
> 
> i guess talking about it instead of posting patches is a factor ;-)

There's several using init_MUTEX() (~70 or so), reviewing a few they
look fairly trivial ..

Daniel


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYESPWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYESPWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYESPWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:22:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYESPWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:22:34 -0400
Date: Mon, 19 May 2008 17:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, sam@ravnborg.org, acme@redhat.com,
       srostedt@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Pekka Paalanen <pq@iki.fi>, proski@gnu.org,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, a.p.zijlstra@chello.nl,
       paulus@samba.org, Sebastian Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] ftrace: add have dynamic ftrace config for archs
Message-ID: <20080519152159.GA2000@elte.hu>
References: <20080514063055.GA21369@elte.hu> <20080514065156.GA3159@uranus.ravnborg.org> <20080514070148.GA10549@elte.hu> <20080514.001150.119391237.davem@davemloft.net> <Pine.LNX.4.58.0805162349570.13829@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0805162349570.13829@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Now that ftrace is being ported to other architectures, it has become 
> apparent that DYNAMIC_FTRACE is dependent on whether or not that 
> architecture implements dynamic ftrace. FTRACE itself may be ported to 
> an architecture without porting dynamic ftrace.
> 
> This patch adds HAVE_DYNAMIC_FTRACE to allow architectures to port 
> ftrace without having to also port the dynamic aspect as well.

applied, thanks Steven.

	Ingo

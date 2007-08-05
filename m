Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbXHERxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbXHERxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXHERxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:53:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbXHERxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:53:36 -0400
Date: Sun, 5 Aug 2007 19:53:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RT] put in a relatively high number for rcu read lock
	upper limit.
Message-ID: <20070805175310.GB3244@elte.hu>
References: <1186289484.636.5.camel@localhost.localdomain> <1186290332.636.8.camel@localhost.localdomain> <20070805065948.GB515@elte.hu> <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com> <20070805150449.GA19418@linux.vnet.ibm.com> <1186328100.636.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186328100.636.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Paul and Ingo,
> 
> Should we just remove the upper limit check, or is something like this 
> patch sound?

i've changed the limit to 30 (the same depth limit is used by lockdep).

beyond that we could get stack overflow, etc.

	Ingo

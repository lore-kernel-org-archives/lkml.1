Return-Path: <linux-kernel-owner+w=401wt.eu-S1761095AbXFFJqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761095AbXFFJqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXFFJqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:46:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32987 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXFFJqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:46:17 -0400
Date: Wed, 6 Jun 2007 11:45:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
Message-ID: <20070606094548.GA9511@elte.hu>
References: <1181096244.6018.20.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181096244.6018.20.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> This fix avoids this race by making sure *after* we've locked the 
> tasklet that the STATE_SCHED bit is set before adding it to the list.
> 
> Does it look ok to you?

ah - nice!! What would be the worst-case effect of this bug? (besides 
the WARN_ON()?) In any case, this fix will be in -rt10. Great work!

	Ingo

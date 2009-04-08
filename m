Return-Path: <linux-kernel-owner+w=401wt.eu-S934358AbZDHQmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbZDHQmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZDHQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:42:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59787 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZDHQmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:42:00 -0400
Date: Wed, 8 Apr 2009 18:41:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][GIT PULL] x86, function-graph: only save return values
	on x86_64
Message-ID: <20090408164118.GC14449@elte.hu>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com> <alpine.DEB.2.00.0903251625490.5675@gandalf.stny.rr.com> <20090408160915.GD16759@elte.hu> <alpine.DEB.2.00.0904081234550.5797@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904081234550.5797@gandalf.stny.rr.com>
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

> > do we still need this for -tip?
> 
> I've ran it without issues. It will help speed up the function 
> graph tracer since it removes a bunch of copies at every function 
> call. But I would test it in your work suite, since I only tested 
> it on two boxes.

ok, great - i've applied it to tip:tracing/ftrace.

	Ingo

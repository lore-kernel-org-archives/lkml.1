Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYLDPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYLDPhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYLDPhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:37:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYLDPhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:37:20 -0500
Date: Thu, 4 Dec 2008 16:36:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
Message-ID: <20081204153626.GB18293@elte.hu>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <20081204001803.598063f5.akpm@linux-foundation.org> <20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdu0t7tz.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> >> 
> >> What does this patch actually do?  Is swapper currently excluded from 
> >> tracing for undisclosed reasons and this patch permits it to be traced? 
> >> If so, why was swapper thus excluded?  Or am I totally off track?
> >
> >> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
> >> 
> >> eh?
> >
> > all side-effects of getting rid of the integer based PID namespace 
> > and replacing them with struct pid pointers.
> 
> Thanks for asking Andrew it looks like an unnecessary side effect.

Will wait for how the end result looks like ;-)

	Ingo

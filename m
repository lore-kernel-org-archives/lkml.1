Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYKZGcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYKZGcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYKZGcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:32:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYKZGcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:32:24 -0500
Date: Wed, 26 Nov 2008 07:32:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       fweisbec@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       srostedt@redhat.com, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
Message-ID: <20081126063201.GF9732@elte.hu>
References: <20081125223456.976670734@goodmis.org> <20081125144221.66eb99ad.akpm@linux-foundation.org> <alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com> <20081125153104.ecdceed4.akpm@linux-foundation.org> <alpine.DEB.1.10.0811251909320.26424@gandalf.stny.rr.com> <1227660839.12109.52.camel@nimitz> <alpine.DEB.1.10.0811251956570.26424@gandalf.stny.rr.com> <m1zljndrb6.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0811260000400.26424@gandalf.stny.rr.com> <m1abbnc8ff.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abbnc8ff.fsf@frodo.ebiederm.org>
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

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > On Tue, 25 Nov 2008, Eric W. Biederman wrote:
> >
> > I'm speechless too.
> 
> I'm a bit tired so probably am pushing to hard.
> 
> At the same time I don't see a single reason not to use struct pid 
> for what it was designed for.  Identifying tasks. pid_t's really 
> only belong at the border.
> 
> I can see in the tracer when grabbing numbers you might not be able 
> to follow pointers.  For that I see justification for using 
> task->pid.  For the comparison I just don't see it.

i dont see the point of the complexity you are advocating. 99.9% of 
the users run a unique PID space.

Tracing is about keeping stuff simple. On containers we could also 
trace the namespace ID (is there an easy ID for the namespace, as an 
easy extension to the very nice PID concept that Unix introduced 
decades ago?) and be done with it.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZDBDSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZDBDSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 23:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZDBDSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 23:18:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbZDBDSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 23:18:37 -0400
Date: Thu, 2 Apr 2009 05:17:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de,
       Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-tip-commits@vger.kernel.org,
       stable@kernel.org
Subject: Re: [tip:tracing/syscalls] tracing/core: fix early free of cpumasks
Message-ID: <20090402031711.GB21545@elte.hu>
References: <1237164303-11476-1-git-send-email-fweisbec@gmail.com> <tip-2fc1dfbe17e7705c55b7a99da995fa565e26f151@git.kernel.org> <20090402011232.GA32066@goodmis.org> <20090402015531.GA12489@elte.hu> <alpine.DEB.2.00.0904012203250.30963@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904012203250.30963@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 2 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > This never made it into 2.6.29, nor do I see it yet in mainline.
> > > 
> > > This can cause unpredictable results with ftrace. We are freeing a 
> > > cpu mask that will be later used.
> > 
> > Yes ... but CONFIG_OFFSTACK is only possible as a debug option right 
> > now. So it's far less serious of an issue, it needs 2-3 unlikely 
> > features to be combined.
> 
> And unfortunately for Johannes, he must have had all those 
> features configured :-/ He spent pretty much the entire day trying 
> to figure out why ftrace was broken.

Okay - will forward the fix to -stable once it's upstream.

	Ingo

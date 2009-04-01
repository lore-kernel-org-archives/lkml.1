Return-Path: <linux-kernel-owner+w=401wt.eu-S1761152AbZDAKVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761152AbZDAKVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZDAKVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:21:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33745 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbZDAKVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:21:09 -0400
Date: Wed, 1 Apr 2009 12:20:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       stuart@freedesktop.org, tglx@linutronix.de
Subject: Re: [tip:x86/urgent] x86: mmiotrace: quieten spurious warning
	message
Message-ID: <20090401102047.GA28574@elte.hu>
References: <tip-afcfe024aebd74b0984a41af9a34e009cf5badaf@git.kernel.org> <20090326220338.1b4ad12e@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326220338.1b4ad12e@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> On Wed, 11 Mar 2009 20:45:45 GMT
> Stuart Bennett <stuart@freedesktop.org> wrote:
> 
> > Commit-ID:  afcfe024aebd74b0984a41af9a34e009cf5badaf
> > Gitweb:     http://git.kernel.org/tip/afcfe024aebd74b0984a41af9a34e009cf5badaf
> > Author:     "Stuart Bennett" <stuart@freedesktop.org>
> > AuthorDate: Wed, 11 Mar 2009 20:29:45 +0000
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 11 Mar 2009 21:41:58 +0100
> > 
> > x86: mmiotrace: quieten spurious warning message
> > 
> > This message was being incorrectly emitted when using gdb,
> > so compile it out by default for now; there will be a
> > better fix in v2.6.30.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
> > Acked-by: Pekka Paalanen <pq@iki.fi>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> 
> Guys,
> 
> wasn't this supposed to go into 2.6.29?
> I don't see this in Linus' master, was it too late?

Correct. There was no showstopper bug in the x86 tree
that necessiated a final post-rc8 push to Linus so this
did not get in.

We'll forward it to -stable once the tracing tree hits
upstream (this week). It could thus be part of .29.1.

	Ingo

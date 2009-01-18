Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbZARH2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbZARH2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbZARH2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:28:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbZARH2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:28:08 -0500
Date: Sun, 18 Jan 2009 08:27:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090118072753.GA3398@elte.hu>
References: <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com> <20090116160202.GA15209@elte.hu> <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com> <20090116163021.GA27495@elte.hu> <20090116225948.GA12314@elte.hu> <alpine.DEB.1.10.0901162003000.9232@gandalf.stny.rr.com> <20090117223451.GA27065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117223451.GA27065@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > This would allow the creation of "surgical" one-time traces - of 
> > > events and functions one is specifically interested in.
> > 
> > This all sounds great, but it would add a lot of conditionals into a 
> > extremely hot function tracer path. [...]
> 
> Why would we need more than exactly one unlikely() condition to handle 
> all of this?

We could even do it with zero branches, burdening none of the hotpaths of 
existing functionality. Hm?

	Ingo

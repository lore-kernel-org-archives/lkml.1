Return-Path: <linux-kernel-owner+w=401wt.eu-S1765293AbZAQWfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765293AbZAQWfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbZAQWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:35:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762196AbZAQWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:35:06 -0500
Date: Sat, 17 Jan 2009 23:34:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090117223451.GA27065@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com> <20090116160202.GA15209@elte.hu> <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com> <20090116163021.GA27495@elte.hu> <20090116225948.GA12314@elte.hu> <alpine.DEB.1.10.0901162003000.9232@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901162003000.9232@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4618]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > This would allow the creation of "surgical" one-time traces - of 
> > events and functions one is specifically interested in.
> 
> This all sounds great, but it would add a lot of conditionals into a 
> extremely hot function tracer path. [...]

Why would we need more than exactly one unlikely() condition to handle all 
of this?

	Ingo

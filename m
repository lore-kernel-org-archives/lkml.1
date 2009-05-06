Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZEFLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZEFLQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZEFLQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:16:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535AbZEFLQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:16:03 -0400
Date: Wed, 6 May 2009 13:15:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: rostedt@goodmis.org, lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sh: remove stray markers
Message-ID: <20090506111549.GJ25203@elte.hu>
References: <20090506103854.GA23811@lst.de> <20090506110735.GH25203@elte.hu> <20090506111209.GA25310@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506111209.GA25310@lst.de>
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


* Christoph Hellwig <hch@lst.de> wrote:

> On Wed, May 06, 2009 at 01:07:35PM +0200, Ingo Molnar wrote:
> > Also, if there's some current use of these markers then it's OK 
> > to not do this change right now but replace them with 
> > tracepoints in the v2.6.31 merge window, after both the SH and 
> > the tracing infrastructure changes are upstream.
> 
> There's not user of these. [...]

I'll defer to Paul to decide whether SH needs those markers. If he 
added them to ease his own debugging (via whatever external 
approach), then that's an OK goal and we can handle this all 
politely without destroying functionality, in the next merge window.

	Ingo

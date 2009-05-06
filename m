Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZEFLH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZEFLH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZEFLHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:07:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51567 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbZEFLHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:07:49 -0400
Date: Wed, 6 May 2009 13:07:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: rostedt@goodmis.org, lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sh: remove stray markers
Message-ID: <20090506110735.GH25203@elte.hu>
References: <20090506103854.GA23811@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506103854.GA23811@lst.de>
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

> arch/sh has a couple of stray markers without any users introduced 
> in commit 3d58695edbfac785161bf282dc11fd42a483d6c9.  Remove them 
> in preparation of removing the markers in favour of the 
> TRACE_EVENT macro (and also because we don't keep dead code 
> around).
> 
> Paul, are you okay putting this in via the tracing tree?  I'd like 
> to have all marker removals queued up there so we can kill it in 
> one go once 2.6.31 opens.

It's fine with me to have this included in the SH tree as well. The 
process.c files tend to be frequently modified in architectures so 
having overlap between tip/tracing and the SH tree could become 
awkward to Paul.

Also, if there's some current use of these markers then it's OK to 
not do this change right now but replace them with tracepoints in 
the v2.6.31 merge window, after both the SH and the tracing 
infrastructure changes are upstream.

	Ingo

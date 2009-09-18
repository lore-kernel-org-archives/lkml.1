Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZIRKXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZIRKXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 06:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZIRKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 06:23:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbZIRKXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 06:23:42 -0400
Date: Fri, 18 Sep 2009 12:23:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill markers
Message-ID: <20090918102334.GA24638@elte.hu>
References: <20090917173527.GA1699@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917173527.GA1699@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0024]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> Now that the last users of markers have migrated to the event tracer 
> we can kill off the support code.

Applied, thanks Christoph!

Btw., there's some more marker related bits in the kernel, such as 
scripts/mod/modpost.c - mostly the effects of:

  b2e3e65: Linux Kernel Markers: create modpost file

I think we want to keep those bits, for those who want to use new 
modpost with an older kernel - but mark them for deprecation.

Thanks,

	Ingo

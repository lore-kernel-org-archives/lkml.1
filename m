Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYAYQ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYAYQ65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYAYQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:58:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbYAYQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:58:49 -0500
Date: Fri, 25 Jan 2008 17:58:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Dropping some patches from sched-devel
Message-ID: <20080125165837.GA19377@elte.hu>
References: <3d8471ca0801250838h2d1f21f2n95c70bc26e28d310@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0801250838h2d1f21f2n95c70bc26e28d310@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0974]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> Hi Ingo,
> 
> Can I talk you into dropping these patches of mine from sched-devel 
> (or not send them to Linus):
> 
> da0f9440cdcb1edd5424de91f326de83de3fe5f9 sched: make sure jiffies is
> up to date before calling __update_rq_clock()
> 6eb300ad38fef6db4efe177067a65aaa771596da sched: fix rq->clock
> overflows detection with CONFIG_NO_HZ
> 
> They are not of good enough quality, and I'm working on a better 
> approach.

sure, done.

what method are you using of determining quality? Could you perhaps try 
to automate it? (even better would be some self-test within the kernel 
that detects badness)

	Ingo

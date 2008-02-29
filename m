Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbYB2P6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbYB2P6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYB2P6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:58:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbYB2P57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:57:59 -0500
Date: Fri, 29 Feb 2008 16:57:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Interactivity issue in 2.6.25-rc3
Message-ID: <20080229155741.GF27248@elte.hu>
References: <20080228184407.GA7117@localhost.ift.unesp.br> <20080228191824.GA20019@elte.hu> <2c0942db0802281154y3176e847g8b9a4091df5cc8af@mail.gmail.com> <20080228210627.GA4337@localhost.ift.unesp.br> <2c0942db0802281328y276d110cqbcc9cfe92f0c6832@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0802281328y276d110cqbcc9cfe92f0c6832@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ray Lee <ray-lk@madrabbit.org> wrote:

> But it's good to keep in mind that the scheduler can't do anything 
> about slowdowns due to tasks being swapped out or waiting on reads 
> from the disk. I mention this as shortly after CFS got into mainline, 
> something changed in the VM that seems to make my system spend a lot 
> more time in IO wait, causing the system to be much less responsive 
> than it used to be.
> 
> Unfortunately it seems to be dependent upon the history of what tasks 
> I've run and their memory usage, so it's been hard to come up with a 
> reproducible test case (well that and a complete lack of time). All I 
> can say is that I've seen what you've reported as well, though it had 
> nothing to do with using any 3d applications, just a browser, editor, 
> gcc, etc.

what does latencytop say about those delays, what causes them? It should 
be able to capture all sorts of latency sources in the system.

	Ingo

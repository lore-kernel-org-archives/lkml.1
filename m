Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYC0KpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYC0KpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYC0KpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:45:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYC0KpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:45:05 -0400
Date: Thu, 27 Mar 2008 11:43:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulus@samba.org,
       tglx@linutronix.de, mingo@redhat.com, tony.luck@intel.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and
	smp_call_function_single()
Message-ID: <20080327104359.GC26725@elte.hu>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu> <20080321131558.GA15355@kernel.dk> <20080327100802.GD15003@elte.hu> <20080327103707.GH12346@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327103707.GH12346@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> I very much wanted the kthread approach to work, since it's easier to 
> work with. It's not for lack of will or trying... I'll be happy to 
> supply you otherwise identical patches for this, the only difference 
> being kthread of IPI completions if you want to play with this.

i'd love to be able to run/pull something simple that enables me to 
replicate the measurements you did on a generic PC [without having to 
hit any real IO hardware which would put any context switching effects 
down into the noise category].

Obviously since the kthread approach embedds IPI sending it can never be 
as fast as a pure IPI approach - but it should still be reasonably fast. 
3 usecs versus 2 usecs in a microbenchmark sounds about right to me, but 
it would be better to make it a better-sounding 2.5 usecs versus 2 usecs 
or so :-)

	Ingo

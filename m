Return-Path: <linux-kernel-owner+w=401wt.eu-S1765097AbXEVJ0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765097AbXEVJ0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXEVJZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:25:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43959 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbXEVJZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:25:52 -0400
Date: Tue, 22 May 2007 11:24:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070522092439.GA19895@elte.hu>
References: <20070522070738.GI4705@kernel.dk> <404129.76498.qm@web52610.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404129.76498.qm@web52610.mail.re2.yahoo.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:

> Just another data point: with the flick of CONFIG_SMP, I'm in control 
> of the hangs/crashes ;-).
> 
> Yup, with CONFIG_SMP=n, I'm unable to reproduce the problem. It's 
> quite stable actually (having completed a dozen kernel compile 
> sessions so far).
> 
> I suspected this after seeing spinlock issues on both cores of my CPU 
> in my earlier report. Just a stab in the dark with some unexpected 
> luck :-).

could you enable CONFIG_PROVE_LOCKING - does it spit out any warning 
into the syslog?

	Ingo

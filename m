Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZFGNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZFGNZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZFGNZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:25:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbZFGNZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:25:18 -0400
Date: Sun, 7 Jun 2009 15:25:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: types for storing instruction pointers
Message-ID: <20090607132516.GB12088@elte.hu>
References: <20090604131400.GA31596@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604131400.GA31596@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> Currently the _THIS_IP_ and _RET_IP_ macros aded for lockdep but 
> now available from kernel.org case the instruction pointer to an 
> unsigned long.  But the %pf/%pF format for printing them want a 
> pointer of some sort.  That's a pretty nasty situation for tracers 
> - can we standardize on one type for it?

Yes but what's the practical problem exactly? Could you cite an 
example?

Thanks,

	Ingo

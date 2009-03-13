Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZCMAq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZCMAq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbZCMAqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:46:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140AbZCMAqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:46:16 -0400
Date: Fri, 13 Mar 2009 01:45:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Newall <davidn@davidnewall.com>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] (latest tip) make dequeue_task less confusing
Message-ID: <20090313004558.GD19544@elte.hu>
References: <49B8CE2B.8070402@davidnewall.com> <20090312095518.GB16721@elte.hu> <1236864997.6075.22.camel@marge.simson.net> <49B94E43.6000405@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B94E43.6000405@davidnewall.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* David Newall <davidn@davidnewall.com> wrote:

> Mike Galbraith wrote:
> > Is there any real gain from doing this?  It messes up the symmetry of
> > enqueue/dequeue.
> 
> 
> No.  On further consideration, I don't like my patch.

With the __dequeue_task()+inline suggestion i made i think it 
would be a micro-optimization and would not break symmetry in a 
significant way.

	Ingo

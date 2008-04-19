Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbYDSSt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbYDSSt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYDSStt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:49:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbYDSSts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:49:48 -0400
Date: Sat, 19 Apr 2008 20:49:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler changes for v2.6.26
Message-ID: <20080419184936.GA1865@elte.hu>
References: <20080419181304.GB21353@elte.hu> <3d8471ca0804191147q3af7f01ei86b23b75bd0eb559@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0804191147q3af7f01ei86b23b75bd0eb559@mail.gmail.com>
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


* Guillaume Chazarain <guichaz@gmail.com> wrote:

> On 4/19/08, Ingo Molnar <mingo@elte.hu> wrote:
> >  Guillaume Chazarain (1):
> >       sched: fix rq->clock overflows detection with CONFIG_NO_HZ
> 
> This one should have been dropped (per 
> http://lkml.org/lkml/2008/1/25/413) I don't like rq->clock relying on 
> jiffies, and you already fixed the original manifestation of the 
> problem in:

no, it was still needed on a testbox of Peter on nohz.

	Ingo

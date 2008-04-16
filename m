Return-Path: <linux-kernel-owner+w=401wt.eu-S1765288AbYDPUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765288AbYDPUrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYDPUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:47:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYDPUrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:47:15 -0400
Date: Wed, 16 Apr 2008 22:47:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, nouveau@lists.freedesktop.org
Subject: Re: [BUG/PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080416204703.GD20762@elte.hu>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi> <20080413230552.33ca587a@daedalus.pq.iki.fi> <20080414065713.GB16163@elte.hu> <20080414210242.2329997d@daedalus.pq.iki.fi> <20080416114609.GA20054@elte.hu> <20080416205902.6186d349@daedalus.pq.iki.fi> <20080416183258.GA30490@elte.hu> <20080416234209.221b7fae@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416234209.221b7fae@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> > So i think we need to fix your automatic-cpudown/cpuup patch. I 
> > tried that and it worked very intuitively and the cpus were 
> > disabled/enabled without any trouble - with ftrace based mmiotrace 
> > we now basically have something that most distros could enable by 
> > default without thinking twice about it.
> 
> Without any trouble - you didn't hit the bug I did?

i did get the warning both on enable/disable but it still worked.

	Ingo

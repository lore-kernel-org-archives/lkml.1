Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZAKBI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZAKBI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZAKBIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:08:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZAKBIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:08:18 -0500
Date: Sun, 11 Jan 2009 02:07:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] irq: initialize nr_irqs based on nr_cpu_ids
Message-ID: <20090111010757.GC12885@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.900264000@polaris-admin.engr.sgi.com> <20090110225010.GD17917@elte.hu> <49692D39.3090801@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49692D39.3090801@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> > function instead, and also sync it up with the current NR_IRQS sizing 
> > macro.
> 
> If mine is not the latest, then I think I'm a victim if git-remote 
> update not updating again as I did that before applying the changes and 
> then copied it in.

i meant something else: 'sync up' in the sense of not duplicating the same 
rules. Should someone else change it - it's easy to miss the 'other' site 
where we size. So my suggestion is to unify them into a single helper 
inline or macro.

	Ingo

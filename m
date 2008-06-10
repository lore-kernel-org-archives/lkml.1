Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYFJMvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYFJMvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYFJMvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:51:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbYFJMvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:51:42 -0400
Date: Tue, 10 Jun 2008 14:51:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Kill off dead cfs_rq_set_shares().
Message-ID: <20080610125129.GA26585@elte.hu>
References: <20080609081224.GA11751@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609081224.GA11751@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0255]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> Building with CONFIG_FAIR_GROUP_SCHED=y on UP results in an unused 
> cfs_rq_set_shares() reference. As nothing is using this dummy function 
> in the first place, just kill it off.
> 
> Against current git, but still seems to be relevant to 'sched-devel' 
> in -tip.

applied, thanks Paul.

	Ingo

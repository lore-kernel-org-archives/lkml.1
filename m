Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbZACSN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbZACSN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbZACSNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:13:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57720 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbZACSNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:13:48 -0500
Date: Sat, 3 Jan 2009 19:13:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
Message-ID: <20090103181333.GA19413@elte.hu>
References: <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com> <20090103150634.GA28693@elte.hu> <495F84D8.1070404@sgi.com> <20090103154733.GA8111@elte.hu> <20090103160017.GA8920@elte.hu> <495F8DCA.1060905@sgi.com> <20090103174520.GA16704@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103174520.GA16704@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Also, while bisecting this window of commits i found that neither would 
> build successfully due to a typo - and the typo is fixed in 095fb96. So 
> since we rebase this portion anyway due to excessive amount of bugs, 
> i'll make it fully bisectable by rebasing right at 095fb96, backmerge 
> the fixlet from eeff031 and redo the whole series dropping the two bad 
> patches. Since this portion of the tree has no appreciable testing value 
> the rebase is the right thing to do here.

okay, i've done this now and pushed out the resulting tree to 
tip/cpus4096-v2. It is a no-content-changed reshuffle of the tail ~10 
commits of tip/cpus4096:

 $ git diff cpus4096..cpus4096-v2
 $

i dropped the two broken patches i bisected today, and backmerged a fixlet 
to make it more bisectable, and reordered fixes next to the merge point - 
and the new changes now come after that.

this finally is something that has no known regressions and looks pushable 
to Linus. I've started the -tip tests, lets see how well this holds up 
now.

	Ingo

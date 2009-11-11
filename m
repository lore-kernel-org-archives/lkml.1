Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZKKLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZKKLcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZKKLcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:32:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZKKLcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:32:17 -0500
Date: Wed, 11 Nov 2009 12:31:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091111113147.GB7487@elte.hu>
References: <4AF90254.40909@kernel.org>
 <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain>
 <4AF9B1FD.1010408@kernel.org>
 <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
 <4AF9BE3A.40409@kernel.org>
 <20091110193705.GA9011@elte.hu>
 <4AF9C402.9040800@kernel.org>
 <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
 <4AFA35CB.5030801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA35CB.5030801@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Linus Torvalds wrote:
> > I want the cleanup because I think that the code sucks from a "future 
> > proofing" and readability standpoint, but I really don't mind one way or 
> > the other whether you want to finally do that one "return 1" correctly for 
> > one commit, only to then fix it to not do that three-way test of a single 
> > function in the next one.
> > 
> > So whatever works - as long as the end result both looks sane and doesn't 
> > have the bug we clearly have now.
> 
> I was mostly worrying about introducing unrelated bug while changing. 
> Anyways, one patch it is.  I'll route it through tip as suggested by 
> Ingo in a few hours.

Btw., i'd suggest you keep it in your percpu tree as usual and send it 
to Linus directly - i offered testing for the cleanup patch (and can 
pull your patch for such a purpose), it doesnt 'have' to go via -tip.

	Ingo

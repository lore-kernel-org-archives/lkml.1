Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYJJSRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYJJSRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYJJSR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:17:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbYJJSR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:17:28 -0400
Date: Fri, 10 Oct 2008 20:17:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #2 - PAT
	updates
Message-ID: <20081010181711.GA25973@elte.hu>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu> <20081010170426.GA5947@elte.hu> <20081010174131.GA8806@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010174131.GA8806@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i merged your latest tree to tip/x86/pat and compared that to pat2, 
> and the difference is zero:
> 
>   earth4:~/tip> git diff x86/pat x86/pat2
>   earth4:~/tip>
> 
> which is the expected result.

Note: one detail i just noticed, x86/pat grew a new commit today, to fix 
a bug that affected Xen:

b27a43c: x86, cpa: make the kernel physical mapping initialization a two pass se

this is in pat2 (and hence included in the pull request as well), but 
was not included in my first phase2 pull request ~17 hours ago.

So if you diffed old phase2 against new phase2 that commit might stick 
out as a weird delta.

	Ingo

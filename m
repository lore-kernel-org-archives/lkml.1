Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbYAaVSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbYAaVSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYAaVSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:18:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYAaVSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:18:38 -0500
Date: Thu, 31 Jan 2008 22:18:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-ID: <20080131211817.GA21210@elte.hu>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi> <20080131130529.b0e17815.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131130529.b0e17815.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > A commit that does nothing except for adding two unused 
> > EXPORT_SYMBOL's.
> > 
> > Without any rationale why they should be exported.
> 
> Don't look at me.  This has been sitting in my tree for nearly two 
> years as part of the reiser4 patchset.  It may not even be needed any 
> more.  I guess Ingo went on a fishing expedition and liked the change.

yes, i picked it up from -mm (as can be seen from the SOB line), and i 
agreed with that change regardless of the reiser4 patchset. (which might 
never see the light of upstream acceptance)

there's nothing more annoying than incomplete and inconsistent APIs. I'm 
trying to fix them up everywhere i see, and this is one of those cases. 
Adrian still has not given any rationale about why he wants to see the 
export removed.

	Ingo

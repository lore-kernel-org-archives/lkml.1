Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZHXIxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZHXIxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZHXIxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:53:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZHXIxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:53:24 -0400
Date: Mon, 24 Aug 2009 10:53:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the s390 tree
Message-ID: <20090824085313.GB29804@elte.hu>
References: <20090824170119.57cf4f59.sfr@canb.auug.org.au> <20090824081723.GA4798@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824081723.GA4798@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Aug 24, 2009 at 05:01:19PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the tip tree got a conflict in
> > arch/s390/kernel/time.c between commit
> > 6342887c12d79c5a2c8c1de5be6f483e16a2acdd ("[S390] introduce
> > get_clock_monotonic") from the s390 tree and commit
> > 23970e389e9cee43c4b41023935e1417271708b2 ("timekeeping: Introduce
> > read_boot_clock") from the tip tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> I reverted the sched_clock_base_cc rename. The merge conflict
> should be gone as soon as Martin pushes a new tree out.

thanks Heiko.

Note that such simpler conflicts can be kept just fine (i.e. there's 
no hard need to revert) - especially now that Stephen has already 
resolved it and tested the end result, and git-rerere will pick it 
up in the future too.

The most valuable conflicts in linux-next are the ones that show 
conflicts that should never occur: which happen due to trees doing 
changes they should not do.

	Ingo

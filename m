Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbZCQJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbZCQJ3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZCQJ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:29:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZCQJ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:29:28 -0400
Date: Tue, 17 Mar 2009 10:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: Tree for March 16 (slob)
Message-ID: <20090317092902.GA6477@elte.hu>
References: <20090316220609.6f4a884c.sfr@canb.auug.org.au> <49BE9B20.70808@oracle.com> <20090317111129.5bf04ae6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317111129.5bf04ae6.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Mon, 16 Mar 2009 11:32:00 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > mm/slob.c:480: error: 'flags' undeclared (first use in this function)
> > 
> > pseudo-patch:
> > 
> > s/flags/gfp/
> 
> Caused by commit cf40bd16fdad42c053040bcd3988f5fdedbb6c57 ("lockdep:
> annotate reclaim context (__GFP_NOFS)") from the tracing tree.
> 
> Now fixed in the tip tree.

Note this has been broken for a relatively long time and only 
got fixed when i noticed that randconfig was not as random as it 
was supposed to be. That's how it started triggering in 
linux-next too i suspect.

	Ingo

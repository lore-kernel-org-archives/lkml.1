Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbYL3GOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYL3GOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYL3GOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:14:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYL3GOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:14:11 -0500
Date: Tue, 30 Dec 2008 07:13:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ijc@hellion.org.uk
Subject: Re: early fixmap causes kmap breakage
Message-ID: <20081230061344.GA28281@elte.hu>
References: <20081218211543.GB10681@wotan.suse.de> <20081229151731.2a2c5a02.akpm@linux-foundation.org> <20081230040118.GA27679@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230040118.GA27679@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Dec 29, 2008 at 03:17:31PM -0800, Andrew Morton wrote:
> > On Thu, 18 Dec 2008 22:15:43 +0100
> > Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > Hi,
> > > 
> > > I've debugged a problem where i386+pae systems with more than a few CPUs
> > > blow up at boot in the kmap_atomic code.
> > 
> > ping?
> 
> No further progress here, I'm waiting on input for how to fix this 
> "nicely". Meantime, clearing the early fixmap pte I guess works, but you 
> lose a page... is it possible to put it into .initdata or is there some 
> issue with that? (I guess on a PAE kernel, 4K isn't a big deal).

yeah, 4K shouldnt be a big deal. Mind sending a patch for this?

	Ingo

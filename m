Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbZJMGk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbZJMGk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbZJMGk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:40:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52939 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbZJMGk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:40:58 -0400
Date: Tue, 13 Oct 2009 08:40:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20091013064006.GC9470@elte.hu>
References: <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu> <20091013040515.GI18578@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013040515.GI18578@obsidianresearch.com>
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


* Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Mon, Oct 12, 2009 at 10:20:46PM +0200, Ingo Molnar wrote:
> > It might be more acceptable because the flag-hint mechanism can at most 
> > cause over-flushing - while with perf events we might miss to invalidate 
> > a range altogether.
> 
> Right. Overflushing is not important, but missing an event entirely is 
> not recoverable (at least within the current kernel APIs).

So if we detect event loss in the perf event case (should not happen 
with sufficient buffering but it is a possibility the code should be 
prepared for) then we can just flush the [0,-1ULL] range, right?

	Ingo

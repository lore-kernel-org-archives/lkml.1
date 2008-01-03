Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYACI4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYACI4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYACIz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:55:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51684 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbYACIz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:55:57 -0500
Date: Thu, 3 Jan 2008 09:55:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Message-ID: <20080103085525.GB10813@elte.hu>
References: <20071218211539.250334036@redhat.com> <200712201859.12934.nickpiggin@yahoo.com.au> <477C1FB6.5050905@sgi.com> <200801031707.14607.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801031707.14607.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Have you done anything more with allowing > 256 CPUS in this 
> > spinlock patch?  We've been testing with 1k cpus and to verify with 
> > -mm kernel, we need to "unpatch" these spinlock changes.
> 
> Hi Mike,
> 
> Actually I had it in my mind that 64 bit used single-byte locking like 
> i386, so I didn't think I'd caused a regression there.
> 
> I'll take a look at fixing that up now.

thanks - this is a serious showstopper for the ticket spinlock patch. 

( which has otherwise been performing very well in x86.git so far - it 
  has passed a few thousand bootup tests on 64-bit and 32-bit as well, 
  so we are close to it being in a mergable state. Would be a pity to
  lose it due to the 256 cpus limit. )

	Ingo

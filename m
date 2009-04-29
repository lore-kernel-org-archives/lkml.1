Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZD2Os3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZD2Os3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZD2OsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:48:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53193 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbZD2OsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:48:06 -0400
Date: Wed, 29 Apr 2009 16:47:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/12] mutex: add atomic_dec_and_mutex_lock
Message-ID: <20090429144712.GA10383@elte.hu>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com> <20090428132742.7da75691.akpm@linux-foundation.org> <20090429115943.GD11586@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429115943.GD11586@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> On Wed, 29 Apr 2009 13:59:43 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> > the locking API bit is already in the locking tree:
> > 
> >   9ab772c: mutex: add atomic_dec_and_mutex_lock()
> > 
> > I added it 23 days ago. Please dont add it to -mm a second time ;-)
> 
> Where is the locking tree?  That commit in the tip tree appears in 
> the middle of a whole lot of perfcounter patches.

Oops, good point. I've put it into tip:core/locking now.

	Ingo

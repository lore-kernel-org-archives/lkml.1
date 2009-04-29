Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZD2MAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZD2MAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZD2MAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:00:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbZD2MAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:00:31 -0400
Date: Wed, 29 Apr 2009 13:59:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 01/12] mutex: add atomic_dec_and_mutex_lock
Message-ID: <20090429115943.GD11586@elte.hu>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com> <20090428132742.7da75691.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428132742.7da75691.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 27 Apr 2009 17:53:05 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> > Much like the atomic_dec_and_lock() function in which we take and hold a
> > spin_lock if we drop the atomic to 0 this function takes and holds the
> > mutex if we dec the atomic to 0.
> 
> I sucked these patches into -mm, mainly for a bit of compile-time 
> and runtime testing.

the locking API bit is already in the locking tree:

  9ab772c: mutex: add atomic_dec_and_mutex_lock()

I added it 23 days ago. Please dont add it to -mm a second time ;-)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbYI1HOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbYI1HOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 03:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYI1HOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 03:14:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYI1HOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 03:14:10 -0400
Date: Sun, 28 Sep 2008 09:13:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dylan Taft <d13f00l@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: mtrr_cleanup hole size should be less than half
	of chunk_size v2
Message-ID: <20080928071350.GA3624@elte.hu>
References: <1222572366-24424-1-git-send-email-yhlu.kernel@gmail.com> <86802c440809272258x1c418f0j7f274dfdfd8a87f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809272258x1c418f0j7f274dfdfd8a87f6@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sat, Sep 27, 2008 at 8:26 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > v2: should check with half of range0 size instead of chunk_size
> >
> > So don't have silly big hole.
> >
> > in hpa's case we could auto detect instead of adding mtrr_chunk_size in command line
> >
> > Ingo, please consider to squash this one to previous one
> > |  commit 2313c2793d290a8cc37c428f8622c53f3fe1d6dc
> > |  Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > |  Date:   Sat Sep 27 00:30:08 2008 -0700
> > |
> > |      x86: mtrr_cleanup optimization, v2
> >
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >
> 
> Dylan,
> 
> please try tip/master after Ingo put this patch into it...

applied to tip/x86/mtrr, thanks Yinghai! I've also propagated it to 
tip/master and pushed it out, so Dylan could do a one-stop testing of 
tip/master.

	Ingo

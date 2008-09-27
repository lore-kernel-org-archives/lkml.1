Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYI0Rio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYI0Rio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYI0Rif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:38:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbYI0Rie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:38:34 -0400
Date: Sat, 27 Sep 2008 19:38:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: mtrr_cleanup optimization v2
Message-ID: <20080927173825.GA26047@elte.hu>
References: <1222500608-14855-1-git-send-email-yhlu.kernel@gmail.com> <1222500608-14855-3-git-send-email-yhlu.kernel@gmail.com> <20080927160936.GA29661@elte.hu> <86802c440809271030w7c96946aw8a38ac853daf8cfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809271030w7c96946aw8a38ac853daf8cfa@mail.gmail.com>
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

> On Sat, Sep 27, 2008 at 9:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> fix hpa's t61 with 4g ram
> >>    change layout from
> >>       (n - 1)*chunksize + chunk_size - NC
> >>    to
> >>       n*chunksize - NC
> >
> > applied the three patches to tip/x86/mtrr, thanks Yinghai!
> >
> > i'm wondering, arent 2/3 and 3/3 also for v2.6.27
> 
> let queue to 2.6.28, and later back port to 2.6.27 , 2.6.26 stable

ok.

	Ingo

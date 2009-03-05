Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZCEKmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZCEKmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZCEKmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:42:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbZCEKmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:42:18 -0500
Date: Thu, 5 Mar 2009 11:41:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tglx@linutronix.de,
       James.Bottomley@HansenPartnership.com, jengelh@medozas.de,
       bharrosh@panasas.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Message-ID: <20090305104159.GE32407@elte.hu>
References: <20090305182958Q.fujita.tomonori@lab.ntt.co.jp> <20090305100901.GU11787@kernel.dk> <20090305101436.GV11787@kernel.dk> <20090305192737I.fujita.tomonori@lab.ntt.co.jp> <20090305103023.GW11787@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305103023.GW11787@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > > Totally untested, comments welcome...
> > 
> > Yeah, I think that updating bi_seg_front_size and 
> > bi_seg_back_size at one place, __blk_recalc_rq_segments, is 
> > better. I thought about the same way. But we are already in 
> > -rc7 and this must go into mainline now. So I chose a 
> > less-intrusive way (similar to what we have done in the 
> > past).
> > 
> > As you know, the merging code is really complicated and we 
> > could overlook stuff easily. ;) It might be better to 
> > simplify the merging code a bit.
> 
> If someone (Ingo?) is willing to test the last variant, I'd 
> much rather add that. It does simplify it (imho), and it kills 
> 23 lines while only adding 9. But a quick response would be 
> nice, then I can ask Linus to pull it later today.

sure, can give it a whirl.

Note that your patch in this thread does no apply cleanly. Could 
you please send a pull request of your latest fixes that i could 
pull into tip:out-of-tree for testing purposes?

	Ingo

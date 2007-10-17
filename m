Return-Path: <linux-kernel-owner+w=401wt.eu-S935772AbXJQRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935772AbXJQRei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761733AbXJQRe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:34:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33144 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760738AbXJQRe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:34:29 -0400
Date: Wed, 17 Oct 2007 19:34:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017173408.GA1960@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017172932.GI15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> OK, it is fine, as long as the sglist is cleared initially. And I 
> don't think there's anyway around that, clearly I didn't think long 
> enough before including the memset() removal from Tomo.
> 
> Ingo, please try this rolled up version.
> 
> Linus, this should work. It would probably be best if you first did a 
> git revert on f5c0dde4c66421a3a2d7d6fa604a712c9b0744e5 and then 
> applied the ll_rw_blk.c bit alone. Do you want me to stuff that 
> (revert + patch) into a branch for you to pull?

yep, this one did the trick, it booted up fine twice in a row already!

 Tested-by: Ingo Molnar <mingo@elte.hu>

thanks!

	Ingo

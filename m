Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXLLQdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXLLQdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbXLLQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:33:40 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXLLQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:33:39 -0500
Date: Wed, 12 Dec 2007 09:33:38 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] REQ-flags to/from BIO-flags bugfix
Message-ID: <20071212163337.GL26334@parisc-linux.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <47462F3C.3040700@googlemail.com> <20071122201250.f957e280.akpm@linux-foundation.org> <47466B5D.90607@googlemail.com> <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain> <475FB316.6040804@panasas.com> <475FBFEE.9010009@panasas.com> <20071212151813.GJ26334@parisc-linux.org> <47600715.9000303@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47600715.9000303@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 06:06:45PM +0200, Boaz Harrosh wrote:
> Thats not enough You still need to fix code in ll_rw_blk(), I would
> define a rq_flags_bio_match_mask = 0xf for that. 
> (and also add what Jens called "needed" with the
> BIO_RW_AHEAD selects REQ_FAILFAST.)

Yes, I appreciate it's not enough; that's why I didn't sign-off on it.

Nobody currently sets BIO_RW_AHEAD, so I don't understand why we need to
do anything ;-)

> And I still don't understand why, for example, "Domain Validation" fails
> with the original patch. What sets BIO_RW_FAILFAST and than panics
> on Errors?
> (All I see is this flag set in dm/multipath.c & dm-mpath.c)

No idea ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

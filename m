Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0CBSVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:21:21 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54064 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0CBSVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:21:19 -0500
Date: Tue, 2 Mar 2010 19:21:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org,
       Michael Breuer <mbreuer@majjas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, dmonakhov@openvz.org
Subject: [GIT PULL] single block IO revert (Was "Re: Oops while booting
	2.6.34-rc0 (block pull busted)")
Message-ID: <20100302182117.GW5768@kernel.dk>
References: <201003011615.31709.dmitry.torokhov@gmail.com> <20100302075656.GO5768@kernel.dk> <20100302081547.GP5768@kernel.dk> <hmiocs$p6h$1@dough.gmane.org> <4B8D41C7.1030404@majjas.com> <20100302174250.GA13131@goodmis.org> <20100302174939.GB13131@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302174939.GB13131@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02 2010, Steven Rostedt wrote:
> Ug, Walt, do not remove Cc's when replying to LKML!
> 
> This looks urgent that we revert this commit:
> 
>   9f7cdbc33f36d28e57eaba0093f68f0d14c38c5b
> 
> or find a fix real quick!

We'll revert it asap, no point in wasting time debugging it first.
Linus, please pull:

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      Revert "blkdev: fix merge_bvec_fn return value checks"

 fs/bio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Jens Axboe


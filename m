Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbXKNWx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbXKNWx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXKNWxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:53:46 -0500
Received: from pat.uio.no ([129.240.10.15]:46458 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbXKNWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:53:44 -0500
Subject: Re: [PATCH 3/3] nfs: use ->mmap_prepare() to avoid an AB-BA
	deadlock
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20071114222448.GE31048@wotan.suse.de>
References: <20071114200136.009242000@chello.nl>
	 <20071114201528.514434000@chello.nl> <20071114212246.GA31048@wotan.suse.de>
	 <1195075905.22457.3.camel@lappy>
	 <1195076485.7584.66.camel@heimdal.trondhjem.org>
	 <1195077034.22457.6.camel@lappy>
	 <1195078730.7584.86.camel@heimdal.trondhjem.org>
	 <20071114222448.GE31048@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 17:53:48 -0500
Message-Id: <1195080828.7584.96.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.6, required=12.0, autolearn=disabled, AWL=-0.633)
X-UiO-Scanned: 43FB3B64F2BC84076C1267DF4A0AF6ABC69311CD
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -5 maxlevel 200 minaction 2 bait 0 mail/h: 747 total 5137751 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 23:24 +0100, Nick Piggin wrote:

> mmap()s can be different from read in that the syscall may have little
> relation to when the data gets used. But I guess it's still a best
> effort thing. Fair enough.

Agreed that mmap() is special and very problematic on NFS. However I
can't see how we can improve on the existing models short of some
significant protocol modifications, and so far, nobody has presented the
IETF with a good case for why they need this level of cache consistency.

Cheers
   Trond


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbYCDOZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbYCDOZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYCDOZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:25:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:44346 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753881AbYCDOZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:25:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18lBvceLT4lEtNglH0r2Fgl/7XTo1pV8OsbZr48SI
	Bok7W/Y67hfUDr
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com,
       tomof@acm.org, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <20080304130307.GN6704@kernel.dk>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	 <20080304085944.GG6704@kernel.dk>
	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>
	 <20080304123939.GM6704@kernel.dk>
	 <1204634619.17258.0.camel@homer.simson.net>
	 <1204635515.17258.12.camel@homer.simson.net>
	 <20080304130307.GN6704@kernel.dk>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 15:25:22 +0100
Message-Id: <1204640722.5783.10.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 14:03 +0100, Jens Axboe wrote:

> Re-read my original mail! It states that you should just pull:
> 
> git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> into your linus branch, or just create a test branch off linus' master
> and pull into that. IOW, it's the for-linus branch that you should pull,
> nothing else.

Well, I had a good reason.  You know how to un-pull, I know how to
un-remote to get back to pristine after I'm done testing... guaranteed
without whimpering pathetically on the git list ;-)

Anyway, I checked out the one with the big-fat-hint in it's name
(block-for-linus/for-linus).
Same error.  Git this morning with patches...
	restore_meaning_of_data_len.diff
	seperate_out_padding_from_alignment.diff
...reverted restored me to the originally reported k3b error, nothing
new noted.

If I tested the wrong branch, whack me upside the head, and I'll follow
your pull destructions, and figure out how to un-pull later.

	-Mike


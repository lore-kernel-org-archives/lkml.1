Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbZC3UKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbZC3UKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZC3UJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:09:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45313 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZC3UJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:09:51 -0400
To: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
From: Andi Kleen <andi@firstfloor.org>
References: <20090329082507.GA4242@infradead.org>
	<49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp>
	<49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp>
	<49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
	<alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
	<20090330175544.GX5178@kernel.dk>
	<alpine.LFD.2.00.0903301120200.3948@localhost.localdomain>
	<20090330185414.GZ5178@kernel.dk> <49D11A8D.1090600@garzik.org>
	<1238441043.20607.16.camel@think.oraclecorp.com>
Date: Mon, 30 Mar 2009 22:09:38 +0200
In-Reply-To: <1238441043.20607.16.camel@think.oraclecorp.com> (Chris Mason's message of "Mon, 30 Mar 2009 15:24:03 -0400")
Message-ID: <87ljqmlqm5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:
>
> As far as I know, reiserfs is the only one actively using it to choose
> different code.  It moves a single wait_on_buffer when barriers are on,
> which I took out once to simplify the code.  Ric saw it in some
> benchmark numbers and I put it back in.
>
> Given that it was a long time ago, I don't have a problem with changing
> it to work like all the other filesystems.

When it was a win on reiserfs back then maybe it would be a win
on ext4 or xfs today too?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

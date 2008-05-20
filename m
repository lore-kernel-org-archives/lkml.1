Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbYETTy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbYETTy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbYETTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:54:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20505 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbYETTyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:54:45 -0400
Date: Tue, 20 May 2008 21:54:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Message-ID: <20080520195437.GZ22369@kernel.dk>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520154313.GI16676@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20 2008, Jamie Lokier wrote:
> Does WRITE_BARRIER always cause a flush?  It does not have to
> according to Documentation/block/barrier.txt.  There are caveats about
> tagged queuing "not yet implemented" in the text, but can we rely on
> that?  The documentation is older than the current implementation;
> those caveats might no longer apply.

It does, if you use ordered tags then that assumes write through
caching (or ordered tag + drain + flush after completion).

-- 
Jens Axboe


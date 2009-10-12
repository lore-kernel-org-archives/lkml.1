Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZJLRb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZJLRb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbZJLRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbZJLRb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:31:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: blkdev_issue_flush really issues a WRITE_BARRIER -- is that okay?
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 12 Oct 2009 13:31:25 -0400
Message-ID: <x49hbu4semq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While looking though Christoph's patch to call blkdev_issue_flush for
fsync on block devices, I noticed that it only issues a WRITE_BARRIER.
I don't see how that guarantees that data is on stable storage.  Am I
missing something?  Shouldn't this translate to a FLUSH CACHE or
SYNCHRONIZE CACHE command?

My apologies if this has been discussed before.

Thanks!
Jeff

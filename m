Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYIYP4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYIYP4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYIYP4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:56:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49262 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYIYP4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:56:31 -0400
Date: Thu, 25 Sep 2008 11:53:55 -0400 (EDT)
Message-Id: <20080925.115355.71085765.k-ueda@ct.jp.nec.com>
To: akpm@linux-foundation.org, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [RFC PATCH 0/2] Export lld busy state for request stacking drivers
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Jens, James,

The following patches are the revised version to use lld's private data
instead of backing_dev_info.state for exporting lld busy state.

Please review and give me your opinion.
If all of you have no problem, I'll re-send the patches separately
to each maintainer, Jens and James.

The patches are created on the following commit of for-2.6.28
in linux-2.6-block, but the scsi part can be also applied to
scsi-post-merge-2.6.
---------------------------------------------------------------
commit c5062758edbe59286d7d8e718a59e4d4347ef541
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed Sep 24 13:05:10 2008 +0200

    libata: set queue SSD flag for SSD devices
---------------------------------------------------------------


Previous post and discussions about the interface:
    http://lkml.org/lkml/2008/9/19/138


Summary of the patches:
    1/2: block: add lld busy state exporting interface
    2/2: scsi: export busy state via q->lld_busy_fn()

Thanks,
Kiyoshi Ueda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYIROrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYIROrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYIROq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:46:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbYIROq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:46:57 -0400
Date: Thu, 18 Sep 2008 10:43:56 -0400 (EDT)
Message-Id: <20080918.104356.74754407.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 0/3] block changes for request-based dm-multipath
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The following patches are changes of the block layer for
request-based dm-multipath.
The patches are created on the following commit of for-2.6.28
in linux-2.6-block.
---------------------------------------------------------------
commit 1fd75f9b2e1c273ab145c9bf3e7a8afcbd8be87a
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Sep 16 15:09:28 2008 -0700

    block: cleanup some of the integrity stuff in blkdev.h
---------------------------------------------------------------

No major changes since the last post (http://lkml.org/lkml/2008/9/12/100),
except for following up the differences from 2.6.27-rc6.
(As I said, I don't include patches for refactoring of similar
 interfaces at this time.  The refactoring patches will be posted
 after the request-based dm-multipath work is done.)

Summary of the patches:
  1/3: block: add a request data completion interface
  2/3: block: add a request submission interface
  3/3: block: add a queue flag for request stacking support

Please review and apply.

Thanks,
Kiyoshi Ueda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZCPC30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZCPC30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZCPC3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:44267 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZCPC3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:12 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: [GIT PATCH] block: cleanup patches, take#2
Date: Mon, 16 Mar 2009 11:28:43 +0900
Message-Id: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup

This patchset contains the following 17 cleanup patches.

 0001-ide-use-blk_run_queue-instead-of-blk_start_queuei.patch
 0002-ide-don-t-set-REQ_SOFTBARRIER.patch
 0003-ide-use-blk_update_request-instead-of-blk_end_req.patch
 0004-block-merge-blk_invoke_request_fn-into-__blk_run_.patch
 0005-block-kill-blk_start_queueing.patch
 0006-block-don-t-set-REQ_NOMERGE-unnecessarily.patch
 0007-block-cleanup-REQ_SOFTBARRIER-usages.patch
 0008-block-clean-up-misc-stuff-after-block-layer-timeout.patch
 0009-block-reorder-request-completion-functions.patch
 0010-block-reorganize-request-fetching-functions.patch
 0011-block-kill-blk_end_request_callback.patch
 0012-block-clean-up-request-completion-API.patch
 0013-block-move-rq-start_time-initialization-to-blk_rq_.patch
 0014-block-implement-and-use-__-blk_end_request_all.patch
 0015-block-kill-end_request.patch
 0016-ubd-simplify-block-request-completion.patch
 0017-block-clean-up-unnecessary-stuff-from-block-drivers.patch

It's on top of the current linux-2.6-block/for-2.6.30[1].  Changes
from the last take[2] are.

* IDE changes separated out to 0001-0003
* IDE end_all conversion dropped

Bartlomiej, 0001-0003 are mostly trivial and shouldn't cause too much
merge headaches later.  Can these go through block tree?  I'll base
further IDE changes on top of linux-next/pata-2.6 patchset (whatever
the merge strategy would be).

Thanks.

--
tejun

[1] 6319ec3182b26abecd2fa9ab97c945f0161d4e36
[2] http://thread.gmane.org/gmane.linux.kernel/806280

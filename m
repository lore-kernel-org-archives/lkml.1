Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbXDXIQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbXDXIQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbXDXIQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:16:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24126 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbXDXIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:39 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/15] CFQ IO scheduler patch series
Date: Tue, 24 Apr 2007 10:15:28 +0200
Message-Id: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a series of patches for the CFQ IO scheduler that I'd like to get
some more testing on. The patch series is also scheduled to enter the
next -mm, but if I'd like people to consciously give it a spin on its
own as well. The patches are also available from the 'cfq' branch of the
block layer tree:

git://git.kernel.dk/data/git/linux-2.6-block.git

and I've uploaded a rolled up version here as well:

http://brick.kernel.dk/snaps/cfq-update-20070424

The patch series is essentially a series of cleanups and smaller
optimizations, but there's also a larger change in there (patches 4 to
7) that completely rework how CFQ selects which queue to process. It's
an experimental approach similar to the CFS CPU scheduler, in which
management lists are converted to a single rbtree instead.

So give it a spin if you have the time, and let me know how it performs
and/or feels for you workload and hardware.

 cfq-iosched.c |  676 ++++++++++++++++++++++++++------------------------
 1 file changed, 357 insertions(+), 319 deletions(-)

-- 
Jens Axboe




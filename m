Return-Path: <linux-kernel-owner+w=401wt.eu-S964901AbZKYOlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901AbZKYOlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934738AbZKYOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:41:11 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33708 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934728AbZKYOlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:41:10 -0500
Date: Wed, 25 Nov 2009 15:41:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] two small block/bdi fixes
Message-ID: <20091125144115.GF8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two small patchlets, please pull for 2.6.32.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alex Chiang (1):
      cciss: make device attrs static

Romit Dasgupta (1):
      Thaw refrigerated bdi flusher threads before invoking kthread_stop on them

 drivers/block/cciss.c |   16 ++++++++--------
 mm/backing-dev.c      |    8 ++++++--
 2 files changed, 14 insertions(+), 10 deletions(-)

-- 
Jens Axboe


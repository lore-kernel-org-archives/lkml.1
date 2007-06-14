Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbXFNWJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbXFNWJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXFNWJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:09:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36413 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXFNWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:08:59 -0400
Message-Id: <20070614215817.389524447@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 23:58:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, andrea@suse.de
Subject: [PATCH 00/17] per device dirty throttling -v7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Latest version of the per bdi dirty throttling patches.

Most of the changes since last time are little cleanups and more
detail in the split out of the floating proportion into their
own little lib.

Patches are against 2.6.22-rc4-mm2

A rollup of all this against 2.6.21 is available here:
  http://programming.kicks-ass.net/kernel-patches/balance_dirty_pages/2.6.21-per_bdi_dirty_pages.patch

This patch-set passes the starve an USB stick test..
-- 


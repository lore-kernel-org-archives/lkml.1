Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZELLd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZELLd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759768AbZELLci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:32:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:49849 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbZELLcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:32:36 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: [PATCH 0/2] swim3: use blk_end_request_all()
Date: Tue, 12 May 2009 20:29:45 +0900
Message-Id: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 May 2009 20:31:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against for-2.6.31 branch in the block tree.

Tejun, don't we need to use blk_end_request_all() when we hit the
maximum retry count in swim3_interrupt? Looks like we can't handle a
request properly if we doesn't complete the request there.

There are some other places to use blk_end_request_all if we need to.



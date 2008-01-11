Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbYAKVth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbYAKVth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbYAKVta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:49:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYAKVt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:49:29 -0500
Date: Fri, 11 Jan 2008 16:49:16 -0500 (EST)
Message-Id: <20080111.164916.102581473.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 0/3] block: remove end_{queued|dequeued}_request()
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This patch set removes end_queued_request() and end_dequeued_request(),
which became identical by the blk-end-request patch set.
They just calls __blk_end_request() actually, so users of them are
converted to call __blk_end_request() directly.

This patch set is for the 'for-akpm' branch of your linux-2.6-block.git.
Please review and apply.

Thanks,
Kiyoshi Ueda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXDQHW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXDQHW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXDQHW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:22:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXDQHW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:22:57 -0400
Message-Id: <20070417071046.318415445@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Apr 2007 09:10:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 00/12] per device dirty throttling -v4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The latest version of the per device dirty throttling.

Dropped all the congestion_wait() churn, will contemplate a rename patch.
Reworked the BDI statistics to use percpu_counter.

against 2.6.21-rc6-mm1; the first patch is for easy application.
Andrew can of course just drop the patch it reverts.



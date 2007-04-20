Return-Path: <linux-kernel-owner+w=401wt.eu-S1767134AbXDTP7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767134AbXDTP7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767131AbXDTP7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:59:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767134AbXDTP7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:59:52 -0400
Message-Id: <20070420155154.898600123@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 17:51:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 00/10] per device dirty throttling -v5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The latest version of the per device dirty throttling.

against 2.6.21-rc6-mm1; the first patch is for easy application.
Andrew can of course just drop the patch it reverts.

Merged BDI_DIRTY and BDI_UNSTABLE into BDI_RECLAIMABLE, and multiplied
bdi_stat_delta() by the number of counters summed.

Thanks to Miklos for pointing these out.

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZGMF5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZGMF5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZGMF52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:57:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41372 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZGMF51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:57:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] OOM analysis helper patch series v3
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Message-Id: <20090713144924.6257.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 13 Jul 2009 14:57:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog
 Since v2
   - Dropped "[4/5] add isolate pages vmstat" temporary because it become
     slightly big. Then, I plan to submit it as another patchset.
   - Rewrote many patch description (Thanks! Christoph)
 Since v1
   - Dropped "[5/5] add NR_ANON_PAGES to OOM log" patch
   - Instead, introduce "[5/5] add shmem vmstat" patch
   - Fixed unit bug (Thanks Minchan)
   - Separated isolated vmstat to two field (Thanks Minchan and Wu)
   - Fixed isolated page and lumpy reclaim issue (Thanks Minchan)
   - Rewrote some patch description (Thanks Christoph)

This patch series are tested on 2.6.31-rc2 + mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
==========================

Current OOM log doesn't provide sufficient memory usage information. it cause
make confusion to lkml MM guys. 

this patch series add some memory usage information to OOM log output.




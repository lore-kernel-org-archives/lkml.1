Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbZGIIF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbZGIIF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbZGIIFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:05:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47831 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbZGIIFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:05:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] OOM analysis helper patch series v2
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Message-Id: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 17:05:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ChangeLog
 Since v1
   - Droped "[5/5] add NR_ANON_PAGES to OOM log" patch
   - Instead, introduce "[5/5] add shmem vmstat" patch
   - Fixed unit bug (Thanks Minchan)
   - Separated isolated vmstat to two field (Thanks Minchan and Wu)
   - Fixed isolated page and lumpy reclaim issue (Thanks Minchan)
   - Rewrote some patch description (Thanks Christoph)


Current OOM log doesn't provide sufficient memory usage information. it cause
make confusion to lkml MM guys. 

this patch series add some memory usage information to OOM log.





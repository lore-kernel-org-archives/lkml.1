Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbZFLDeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbZFLDeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZFLDdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:33:53 -0400
Received: from mga10.intel.com ([192.55.52.92]:29880 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751611AbZFLDdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:33:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,206,1243839600"; 
   d="scan'208";a="698696671"
Date: Fri, 12 Jun 2009 11:17:06 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter tools: Remove one L1-data alias
Message-ID: <20090612031706.GA22126@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise all L1-instruction aliases will be recognized as L1-data by strcasestr()
when calling function parse_aliases.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 tools/perf/util/parse-events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9d5f1ca..5a72586 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -75,7 +75,7 @@ static char *sw_event_names[] = {
 #define MAX_ALIASES 8
 
 static char *hw_cache [][MAX_ALIASES] = {
-	{ "L1-data"		, "l1-d", "l1d", "l1"				},
+	{ "L1-data"		, "l1-d", "l1d"					},
 	{ "L1-instruction"	, "l1-i", "l1i"					},
 	{ "L2"			, "l2"						},
 	{ "Data-TLB"		, "dtlb", "d-tlb"				},

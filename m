Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZFCI7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZFCI7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZFCI7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:59:06 -0400
Received: from mga10.intel.com ([192.55.52.92]:37977 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752256AbZFCI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:59:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,297,1241420400"; 
   d="scan'208";a="462935020"
Date: Wed, 3 Jun 2009 16:42:25 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter: documentation update
Message-ID: <20090603084225.GA6553@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'nmi' bit is no longer there.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 design.txt |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/perf_counter/design.txt b/Documentation/perf_counter/design.txt
index 9930c4b..d325076 100644
--- a/Documentation/perf_counter/design.txt
+++ b/Documentation/perf_counter/design.txt
@@ -48,7 +48,6 @@ struct perf_counter_hw_event {
         __u32                   read_format;
 
         __u64                   disabled       :  1, /* off by default        */
-                                nmi            :  1, /* NMI sampling          */
                                 inherit        :  1, /* children inherit it   */
                                 pinned         :  1, /* must always be on PMU */
                                 exclusive      :  1, /* only group on PMU     */
@@ -195,12 +194,6 @@ The 'disabled' bit specifies whether the counter starts out disabled
 or enabled.  If it is initially disabled, it can be enabled by ioctl
 or prctl (see below).
 
-The 'nmi' bit specifies, for hardware events, whether the counter
-should be set up to request non-maskable interrupts (NMIs) or normal
-interrupts.  This bit is ignored if the user doesn't have
-CAP_SYS_ADMIN privilege (i.e. is not root) or if the CPU doesn't
-generate NMIs from hardware counters.
-
 The 'inherit' bit, if set, specifies that this counter should count
 events on descendant tasks as well as the task specified.  This only
 applies to new descendents, not to any existing descendents at the

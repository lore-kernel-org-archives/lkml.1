Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbXJQWkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbXJQWkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXJQWkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:40:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:44215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbXJQWkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="300519129"
Date: Wed, 17 Oct 2007 15:39:54 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix incorrect comment on show_available_freqs() in freq_table.c
Message-ID: <20071017223954.GA4804@linux-os.sc.intel.com>
References: <200707310737.l6V7bQ3j021822@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707310737.l6V7bQ3j021822@imap1.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In freq_table.c, show_available_freqs()'s comment is oberviously wrong. Change
the comment to a new one to avoid confusion. Please apply it.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 freq_table.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 5409f3a..ae6cd60 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -171,7 +171,7 @@ EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 
 static struct cpufreq_frequency_table *show_table[NR_CPUS];
 /**
- * show_scaling_governor - show the current policy for the specified CPU
+ * show_available_freqs - show available frequencies for the specified CPU
  */
 static ssize_t show_available_freqs (struct cpufreq_policy *policy, char *buf)
 {

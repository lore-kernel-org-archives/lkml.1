Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbXJXQYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbXJXQYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXJXQWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:22:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33286 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754836AbXJXQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:44 -0400
Date: Wed, 24 Oct 2007 18:23:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, davej@codemonkey.org.uk
Cc: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 cpufreq.c:cpufreq_get()
Message-ID: <20071024162312.GH30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq.c:cpufreq_get() no longer has any user.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/cpufreq/cpufreq.c |    2 ++
 1 file changed, 2 insertions(+)

099a5401a3c0322177866d4ba4e791825fe921d4 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5e626b1..d27c802 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1143,6 +1143,7 @@ static unsigned int __cpufreq_get(unsigned int cpu)
 	return (ret_freq);
 }
 
+#if 0
 /**
  * cpufreq_get - get the current CPU frequency (in kHz)
  * @cpu: CPU number
@@ -1170,6 +1171,7 @@ out:
 	return (ret_freq);
 }
 EXPORT_SYMBOL(cpufreq_get);
+#endif  /*  0  */
 
 
 /**


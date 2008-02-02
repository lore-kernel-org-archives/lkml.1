Return-Path: <linux-kernel-owner+w=401wt.eu-S935375AbYBBX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935375AbYBBX6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934561AbYBBX5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:57:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:40085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934392AbYBBX5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:57:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/10] Add ja_JP translation of stable_kernel_rules.txt
Date: Sat,  2 Feb 2008 15:55:57 -0800
Message-Id: <1201996564-21951-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>

Contents are reviewed by Japanese translation community called "JF".
Thanks a lot!

Singed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ja_JP/stable_kernel_rules.txt |   79 +++++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ja_JP/stable_kernel_rules.txt

diff --git a/Documentation/ja_JP/stable_kernel_rules.txt b/Documentation/ja_JP/stable_kernel_rules.txt
new file mode 100644
index 0000000..17d8751
--- /dev/null
+++ b/Documentation/ja_JP/stable_kernel_rules.txt
@@ -0,0 +1,79 @@
+NOTE:
+This is Japanese translated version of "Documentation/stable_kernel_rules.txt".
+This one is maintained by Tsugikazu Shibata <tshibata@ab.jp.nec.com>
+and JF Project team <www.linux.or.jp/JF>.
+If you find difference with original file or problem in translation,
+please contact maintainer of this file or JF project.
+
+Please also note that purpose of this file is easier to read for non
+English natives and do no intended to fork. So, if you have any
+comment or update of this file, please try to update Original(English)
+file at first.
+
+==================================
+ããã¯ã
+linux-2.6.24/Documentation/stable_kernel_rules.txt
+ã®åè¨³ã§ãã
+
+ç¿»è¨³å£ä½ï¼ JF ãã­ã¸ã§ã¯ã < http://www.linux.or.jp/JF/ >
+ç¿»è¨³æ¥ï¼ 2007/12/30
+ç¿»è¨³èï¼ Tsugikazu Shibata <tshibata at ab dot jp dot nec dot com>
+æ ¡æ­£èï¼ æ­¦äºä¼¸åããã<takei at webmasters dot gr dot jp>
+         ãã­ããã (Seiji Kaneko) <skaneko at a2 dot mbn dot or dot jp>
+         å°æ éå¸ãã (Masanori Kobayasi) <zap03216 at nifty dot ne dot jp>
+         éå£ãã (Kenji Noguchi) <tokyo246 at gmail dot com>
+         ç¥å®®ä¿¡å¤ªéãã <jin at libjingu dot jp>
+==================================
+
+ãã£ã¨ç¥ãããã£ã Linux 2.6 -stable ãªãªã¼ã¹ã®å¨ã¦
+
+"-stable" ããªã¼ã«ã©ã®ãããªç¨®é¡ã®ããããåãå¥ããããããã©ã®ãããª
+ãã®ãåãå¥ããããªãããã«ã¤ãã¦ã®è¦å-
+
+ - æããã«æ­£ããããã¹ãããã¦ãããã®ã§ãªããã°ãªããªãã
+ - æè(å¤æ´è¡ã®åå¾)ãå«ãã¦ 100 è¡ããå¤§ããã¦ã¯ãããªãã
+ - ãã ä¸åã®ãã¨ã ããä¿®æ­£ãã¦ããã¹ãã
+ - çãæ©ã¾ãã¦ããæ¬ç©ã®ãã°ãä¿®æ­£ããªããã°ãªããªãã("ããã¯ãã°ã§
+   ãããããããªãã..." ã®ãããªãã®ã§ã¯ãªã)
+ - ãã«ãã¨ã©ã¼(CONFIG_BROKENã«ãªã£ã¦ãããã®ãé¤ã), oops, ãã³ã°ããã¼
+   ã¿ç ´å£ãç¾å®ã®ã»ã­ã¥ãªãã£åé¡ããã®ä» "ãããããã¯ãã¡ã ã­"ã¨ãã
+   ãããªãã®ãä¿®æ­£ããªããã°ãªããªããç­ãè¨ãã°ãéå¤§ãªåé¡ã
+ - ã©ã®ããã«ç«¶åç¶æãçºçãããã®èª¬æãä¸ç·ã«æ¸ããã¦ããªãéãã
+   "çè«çã«ã¯ç«¶åç¶æã«ãªã"ãããªãã®ã¯ä¸å¯ã
+ - ãããªãäºç´°ãªä¿®æ­£ãå«ãããã¨ã¯ã§ããªãã(ã¹ãã«ã®ä¿®æ­£ãç©ºç½ã®ã¯ãªã¼
+   ã³ã¢ãããªã©)
+ - å¯¾å¿ãããµãã·ã¹ãã ã¡ã³ãããåãå¥ãããã®ã§ãªããã°ãªããªãã
+ - Documentation/SubmittingPatches ã®è¦åã«å¾ã£ããã®ã§ãªããã°ãªããªãã
+
+-stable ããªã¼ã«ããããéä»ããæç¶ã-
+
+ - ä¸è¨ã®è¦åã«å¾ã£ã¦ããããç¢ºèªããå¾ã«ãstable@kernel.org ã«ããã
+   ãéãã
+ - éä¿¡èã¯ããããã­ã¥ã¼ã«åãä»ããããéã«ã¯ ACK ããå´ä¸ãããå ´å
+   ã«ã¯ NAK ãåãåãããã®åå¿ã¯éçºèãã¡ã®ã¹ã±ã¸ã¥ã¼ã«ã«ãã£ã¦ãæ°
+   æ¥ãããå ´åãããã
+ - ããåãåããããããããã¯ä»ã®éçºèãã¡ã®ã¬ãã¥ã¼ã®ããã«
+   -stable ã­ã¥ã¼ã«è¿½å ãããã
+ - ã»ã­ã¥ãªãã£ãããã¯ãã®ã¨ã¤ãªã¢ã¹ (stable@kernel.org) ã«éãããã¹
+   ãã§ã¯ãªããä»£ããã« security@kernel.org ã®ã¢ãã¬ã¹ã«éãããã
+
+ã¬ãã¥ã¼ãµã¤ã¯ã«-
+
+ - -stable ã¡ã³ãããã¬ãã¥ã¼ãµã¤ã¯ã«ãæ±ºããã¨ãããããã¯ã¬ãã¥ã¼å§
+   å¡ä¼ã¨ããããå½±é¿ããé åã®ã¡ã³ãã(æä¾èããã®é åã®ã¡ã³ããã§ç¡
+   ãéã)ã«éãããlinux-kernel ã¡ã¼ãªã³ã°ãªã¹ãã«CCãããã
+ - ã¬ãã¥ã¼å§å¡ä¼ã¯ 48æéã®éã« ACK ã NAK ãåºãã
+ - ããããããå§å¡ä¼ã®ã¡ã³ãããå´ä¸ããããã¡ã³ããéãã¡ã³ããæ°ä»
+   ããªãã£ãåé¡ãæã¡ããããlinux-kernel ã¡ã³ãããããã«ç°è­°ãå±ã
+   ãå ´åã«ã¯ããããã¯ã­ã¥ã¼ããåé¤ãããã
+ - ã¬ãã¥ã¼ãµã¤ã¯ã«ã®æå¾ã«ãACK ãåãããããã¯ææ°ã® -stable ãªãªã¼
+   ã¹ã«è¿½å ããããã®å¾ã«æ°ãã -stable ãªãªã¼ã¹ãè¡ãããã
+ - ã»ã­ã¥ãªãã£ãããã¯ãéå¸¸ã®ã¬ãã¥ã¼ãµã¤ã¯ã«ãéãããã»ã­ã¥ãªãã£
+   ã«ã¼ãã«ãã¼ã ããç´æ¥ -stable ããªã¼ã«åãä»ããããã
+   ãã®æç¶ãã®è©³ç´°ã«ã¤ãã¦ã¯ kernel security ãã¼ã ã«åãåããããã¨ã
+
+ã¬ãã¥ã¼å§å¡ä¼-
+
+ - ãã®å§å¡ä¼ã¯ããã®ã¿ã¹ã¯ã«ã¤ãã¦æ´»åããå¤ãã®ãã©ã³ãã£ã¢ã¨ãå°æ°ã®
+   éãã©ã³ãã£ã¢ã®ã«ã¼ãã«éçºèéã§æ§æããã¦ããã
+
-- 
1.5.3.8


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYBGH0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYBGH0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYBGH0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:26:14 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:53356 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754677AbYBGH0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:26:13 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-8.tower-29.messagelabs.com!1202369172!5409023!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] fix typo "goot" -> "good"
Date: Thu,  7 Feb 2008 08:26:09 +0100
Message-Id: <1202369169-5909-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202368232-5733-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1202368232-5733-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 Feb 2008 07:26:09.0366 (UTC) FILETIME=[B5889760:01C8695A]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15714.002
X-TM-AS-Result: No--8.723800-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello,

ups, I made a typo myself, how embarrassing.  Sorry for getting this
patch twice.

Best regards
Uwe

 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..35bb5a1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1373,7 +1373,7 @@ sub process {
 
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
-# in a known goot container
+# in a known good container
 		if ($prevline =~ /\#define.*\\/ &&
 		   $prevline !~/(?:do\s+{|\(\{|\{)/ &&
 		   $line !~ /(?:do\s+{|\(\{|\{)/ &&
-- 
1.5.4


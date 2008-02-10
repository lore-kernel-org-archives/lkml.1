Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYBJDMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYBJDMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYBJDMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:12:31 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:34360 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755490AbYBJDMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:12:30 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Silent compiler warning introduced by commit 75b6102257874a4ea796af686de2f72cfa0452f9 (rtc: add support for Epson RTC-9701JE V4)
Date: Sun, 10 Feb 2008 05:10:48 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: damm@igel.co.jp, david-b@pacbell.net, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802100510.49479.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch silents

drivers/rtc/rtc-r9701.c: In function `r9701_get_datetime':
drivers/rtc/rtc-r9701.c:74: warning: unused variable `time'

compiler warning introduced by commit 75b6102257874a4ea796af686de2f72cfa0452f9 (rtc: add support for Epson RTC-9701JE V4)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
 
 drivers/rtc/rtc-r9701.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index a64626a..b35f9bf 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -71,7 +71,6 @@ static int read_regs(struct device *dev, unsigned char *regs, int no_regs)
 
 static int r9701_get_datetime(struct device *dev, struct rtc_time *dt)
 {
-	unsigned long time;
 	int ret;
 	unsigned char buf[] = { RSECCNT, RMINCNT, RHRCNT,
 				RDAYCNT, RMONCNT, RYRCNT };

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!

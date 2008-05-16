Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYEPARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYEPARt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYEPARj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:17:39 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38814 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYEPARi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:17:38 -0400
Date: Fri, 16 May 2008 03:15:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Chia-Ling Lu Developer <chialing@realtek.com.tw>,
       Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] tuners/mxl5005s.c: don't define variables for enums
Message-ID: <20080516001553.GL1936@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't seem to be intended that "tuner_modu_type" and 
"MXL5005_ControlName" were global variables.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/common/tuners/mxl5005s.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

e6a639a06854b75ca90e49e00dfd858cb4c8dd02 diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index 5d05b53..0dc2bef 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -101,7 +101,7 @@ enum {
 	MXL_QAM,
 	MXL_ANALOG_CABLE,
 	MXL_ANALOG_OTA
-} tuner_modu_type;
+};
 
 /* MXL5005 Tuner Register Struct */
 struct TunerReg {
@@ -194,7 +194,7 @@ enum {
 	RFSYN_DIVM,                /* 88 */
 	DN_BYPASS_AGC_I2C          /* 89 */
 #endif
-} MXL5005_ControlName;
+};
 
 /*
  * The following context is source code provided by MaxLinear.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbYA1WMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbYA1WMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbYA1WKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46415 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049AbYA1WKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:04 -0500
Date: Tue, 29 Jan 2008 00:10:31 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb/frontends/xc5000.c: make a struct static
Message-ID: <20080128221030.GP8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct XC5000_Standard[] can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e1f9c8304c807ecce026156ee2185925295fe835 
diff --git a/drivers/media/dvb/frontends/xc5000.c b/drivers/media/dvb/frontends/xc5000.c
index f642ca2..a5094b7 100644
--- a/drivers/media/dvb/frontends/xc5000.c
+++ b/drivers/media/dvb/frontends/xc5000.c
@@ -151,7 +151,7 @@ typedef struct {
 #define FM_Radio_INPUT2 	21
 #define FM_Radio_INPUT1 	22
 
-XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
+static XC_TV_STANDARD XC5000_Standard[MAX_TV_STANDARD] = {
 	{"M/N-NTSC/PAL-BTSC", 0x0400, 0x8020},
 	{"M/N-NTSC/PAL-A2",   0x0600, 0x8020},
 	{"M/N-NTSC/PAL-EIAJ", 0x0440, 0x8020},


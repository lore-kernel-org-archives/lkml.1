Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYLIRMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYLIRMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYLIRMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:12:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:55608 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYLIRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:12:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VG2aWdQvmXGT5jXxCHsB6P9MYNTQihAWYTpLCaoxn8GBTaQpwI1zls58/+pMZ7wd9Y
         A3nUGdSalaCBG0i8ZefB+g5+489Te/EYC6wInx/JPAXRaWLqGNfGp8m/VDrcPryeIJt9
         f0wFyCPlXDgI3kvM3GEp8wKNMp7Ee+V95V0/I=
Message-ID: <493EA704.5070007@gmail.com>
Date: Tue, 09 Dec 2008 18:12:36 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/33] drivers/char: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/char/defkeymap.c_shipped |    6 +++---
 drivers/char/keyboard.c          |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/defkeymap.c_shipped b/drivers/char/defkeymap.c_shipped
index d2208df..e930e3b 100644
--- a/drivers/char/defkeymap.c_shipped
+++ b/drivers/char/defkeymap.c_shipped
@@ -43,7 +43,7 @@ u_short shift_map[NR_KEYS] = {
 	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,
 };
 
-u_short altgr_map[NR_KEYS] = {
+static u_short altgr_map[NR_KEYS] = {
 	0xf200,	0xf200,	0xf200,	0xf040,	0xf200,	0xf024,	0xf200,	0xf200,
 	0xf07b,	0xf05b,	0xf05d,	0xf07d,	0xf05c,	0xf200,	0xf200,	0xf200,
 	0xfb71,	0xfb77,	0xf918,	0xfb72,	0xfb74,	0xfb79,	0xfb75,	0xfb69,
@@ -100,7 +100,7 @@ u_short shift_ctrl_map[NR_KEYS] = {
 	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,
 };
 
-u_short alt_map[NR_KEYS] = {
+static u_short alt_map[NR_KEYS] = {
 	0xf200,	0xf81b,	0xf831,	0xf832,	0xf833,	0xf834,	0xf835,	0xf836,
 	0xf837,	0xf838,	0xf839,	0xf830,	0xf82d,	0xf83d,	0xf87f,	0xf809,
 	0xf871,	0xf877,	0xf865,	0xf872,	0xf874,	0xf879,	0xf875,	0xf869,
@@ -119,7 +119,7 @@ u_short alt_map[NR_KEYS] = {
 	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,
 };
 
-u_short ctrl_alt_map[NR_KEYS] = {
+static u_short ctrl_alt_map[NR_KEYS] = {
 	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,
 	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,	0xf200,
 	0xf811,	0xf817,	0xf805,	0xf812,	0xf814,	0xf819,	0xf815,	0xf809,
diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index de26a97..564f719 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -151,7 +151,7 @@ static struct ledptr {
 /* Simple translation table for the SysRq keys */
 
 #ifdef CONFIG_MAGIC_SYSRQ
-unsigned char kbd_sysrq_xlate[KEY_MAX + 1] =
+static unsigned char kbd_sysrq_xlate[KEY_MAX + 1] =
         "\000\0331234567890-=\177\t"                    /* 0x00 - 0x0f */
         "qwertyuiop[]\r\000as"                          /* 0x10 - 0x1f */
         "dfghjkl;'`\000\\zxcv"                          /* 0x20 - 0x2f */


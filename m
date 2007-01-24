Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbXAXWg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbXAXWg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXAXWg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:36:26 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:3364 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932831AbXAXWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:36:25 -0500
Date: Wed, 24 Jan 2007 23:36:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/media/dvb/frontends/: make 4 functions static
Message-ID: <20070124223631.GS17836@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes four needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 13 Aug 2006

 drivers/media/dvb/frontends/stv0299.c  |    2 +-
 drivers/media/dvb/frontends/tda10021.c |    2 +-
 drivers/media/dvb/frontends/tda1004x.c |    2 +-
 drivers/media/dvb/frontends/zl10353.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/stv0299.c.old	2006-08-13 17:56:46.000000000 +0200
+++ linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/stv0299.c	2006-08-13 17:56:56.000000000 +0200
@@ -92,7 +92,7 @@
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
 
-int stv0299_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int stv0299_write(struct dvb_frontend* fe, u8 *buf, int len)
 {
 	struct stv0299_state* state = fe->demodulator_priv;
 
--- linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/tda10021.c.old	2006-08-13 17:57:25.000000000 +0200
+++ linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/tda10021.c	2006-08-13 17:57:44.000000000 +0200
@@ -201,7 +201,7 @@
 	return 0;
 }
 
-int tda10021_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int tda10021_write(struct dvb_frontend* fe, u8 *buf, int len)
 {
 	struct tda10021_state* state = fe->demodulator_priv;
 
--- linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/tda1004x.c.old	2006-08-13 17:58:23.000000000 +0200
+++ linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/tda1004x.c	2006-08-13 17:58:51.000000000 +0200
@@ -579,7 +579,7 @@
 	return -1;
 }
 
-int tda1004x_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int tda1004x_write(struct dvb_frontend* fe, u8 *buf, int len)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
--- linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/zl10353.c.old	2006-08-13 17:59:09.000000000 +0200
+++ linux-2.6.18-rc4-mm1/drivers/media/dvb/frontends/zl10353.c	2006-08-13 17:59:35.000000000 +0200
@@ -54,7 +54,7 @@
 	return 0;
 }
 
-int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
+static int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
 {
 	int err, i;
 	for (i = 0; i < ilen - 1; i++)


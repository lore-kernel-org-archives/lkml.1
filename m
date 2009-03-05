Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZCETP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZCETP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbZCETO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:14:58 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:45364 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbZCETO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:14:57 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 05/15] NULL noise: drivers/media/dvb/frontends/drx397xD_fw.h
Date: Thu, 05 Mar 2009 20:14:39 +0100
Message-ID: <20090305191435.30062.72139.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/media/dvb/frontends/drx397xD_fw.h:21:2: warning: Using plain integer as NULL pointer
  drivers/media/dvb/frontends/drx397xD_fw.h:22:2: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 drivers/media/dvb/frontends/drx397xD.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index 1e81e71..172f1f9 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -74,7 +74,7 @@ static struct {
 } fw[] = {
 #define _FW_ENTRY(a, b, c)	{					\
 			.name	= a,					\
-			.file	= 0,					\
+			.file	= NULL,					\
 			.lock	= __RW_LOCK_UNLOCKED(fw[c].lock),	\
 			.refcnt = 0,					\
 			.data	= { }		}


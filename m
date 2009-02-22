Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZBVACn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZBVACn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZBVACO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:02:14 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44867 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbZBVACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:02:12 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 05/16] dvb: fix sparse warnings: Using plain integer as NULL
	pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:02:08 +0100
Message-ID: <20090222000204.17557.99725.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/media/dvb/frontends/drx397xD_fw.h:21:2: warning: Using plain integer as NULL pointer
  drivers/media/dvb/frontends/drx397xD_fw.h:22:2: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZCAJZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZCAJZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZCAJVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:21:44 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:40015 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZCAJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:21:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Michael Schmitz <schmitz@debian.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 5/6] m68k: section mismatch fixes: DMAsound for Atari
Date: Sun,  1 Mar 2009 10:21:14 +0100
Message-Id: <1235899275-23630-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235899275-23630-5-git-send-email-geert@linux-m68k.org>
References: <1235899275-23630-1-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-2-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-3-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-4-git-send-email-geert@linux-m68k.org>
 <1235899275-23630-5-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>

add __initdata to driver presets struct

Signed-off-By: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/oss/dmasound/dmasound_atari.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 38931f2..1f47741 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -1524,7 +1524,7 @@ static SETTINGS def_soft = {
 	.speed	= 8000
 } ;
 
-static MACHINE machTT = {
+static __initdata MACHINE machTT = {
 	.name		= "Atari",
 	.name2		= "TT",
 	.owner		= THIS_MODULE,
@@ -1553,7 +1553,7 @@ static MACHINE machTT = {
 	.capabilities	=  DSP_CAP_BATCH	/* As per SNDCTL_DSP_GETCAPS */
 };
 
-static MACHINE machFalcon = {
+static __initdata MACHINE machFalcon = {
 	.name		= "Atari",
 	.name2		= "FALCON",
 	.dma_alloc	= AtaAlloc,
-- 
1.6.1.3


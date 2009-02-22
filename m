Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZBVAGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZBVAGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZBVAGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:06:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:35364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZBVAF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:05:59 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 16/16] ALSA: msnd: fix sparse warning: Using plain integer as
	NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:05:55 +0100
Message-ID: <20090222000552.17557.21537.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  sound/isa/msnd/msnd_pinnacle.c:808:1: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/isa/msnd/msnd_pinnacle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 60b6abd..add6c0a 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -805,7 +805,7 @@ module_param(calibrate_signal, int, S_IRUGO);
 #ifndef MSND_CLASSIC
 module_param_array(digital, int, NULL, S_IRUGO);
 module_param_array(cfg, long, NULL, S_IRUGO);
-module_param_array(reset, int, 0, S_IRUGO);
+module_param_array(reset, int, NULL, S_IRUGO);
 module_param_array(mpu_io, long, NULL, S_IRUGO);
 module_param_array(mpu_irq, int, NULL, S_IRUGO);
 module_param_array(ide_io0, long, NULL, S_IRUGO);


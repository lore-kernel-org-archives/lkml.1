Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbZJJPyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbZJJPyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZJJPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:54:39 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:50086 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZJJPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o3yse2Otv0ihExfBqKKdch+sI1UsruHxgqIL482GcR4YwvrqqtI/wvMv9LxSqwWgxw
         Zpy9b3e1yDmPMl4JFvOPKdSRLC3Wij2EWdOnhjaN3yzf/g1/0p7nIVtjiORm6vMU1lMA
         eAuLEVuKDUN/0UFlleZr/asICK7Sroq3ei1i4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>, loongson-dev@googlegroups.com
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] SND_CS5535AUDIO: Remove the X86 platform dependency
Date: Sat, 10 Oct 2009 23:53:48 +0800
Message-Id: <1255190029-17584-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SND_CS5535AUDIO is available on Loongson(MIPS compatible) family
machines, and checked it with ARCH=x86_64, no relative compiling
warnings & errors, so, remove the platform dependency directly.

Reported-by: rixed@happyleptic.org
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 sound/pci/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index fb5ee3c..75c602b 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -259,7 +259,6 @@ config SND_CS5530
 
 config SND_CS5535AUDIO
 	tristate "CS5535/CS5536 Audio"
-	depends on X86 && !X86_64
 	select SND_PCM
 	select SND_AC97_CODEC
 	help
-- 
1.6.2.1


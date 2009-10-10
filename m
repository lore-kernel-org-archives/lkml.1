Return-Path: <linux-kernel-owner+w=401wt.eu-S934511AbZJJPyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511AbZJJPyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934068AbZJJPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:54:48 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:36750 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060AbZJJPyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cMc/0e0tZbcCSnHPjXEF+74goqBbJFPynKOCP+2zY6qpgiNrM1zhDkeexL29MJLwG/
         h9xDoP9KrigMDDWFr4JKtzt66wlNwa2+15Y3P/MMlHJHEcJ8VsGGUZ+N84RkBQZhg/9r
         kDA5kjAD40fHUtlcS/cR0lHrnV4H65jGGeLas=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>, loongson-dev@googlegroups.com
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] SND_CS5535AUDIO: Remove the X86 platform dependency
Date: Sat, 10 Oct 2009 23:53:49 +0800
Message-Id: <1255190029-17584-2-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1255190029-17584-1-git-send-email-wuzhangjin@gmail.com>
References: <1255190029-17584-1-git-send-email-wuzhangjin@gmail.com>
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


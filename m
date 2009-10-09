Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZJIDow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZJIDow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbZJIDot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:44:49 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:45739 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760216AbZJIDot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OTdVwTZbyFAaedFtBj7zLrkcv1smWL8oXUZJIrzmdcDI5LT12iQbdu7+nbg95YMger
         Apajf53SQvziIUQjguU4+RXQyyI43QE6RpINMYc6/CwUuNQefgttB9IA1sTUgZmmM7vg
         FJCgY4qCx7LbbY6uBYq9pHpWp2vLhHA4FSR9Y=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Cc: Andres Salomon <dilinger@debian.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       loongson-dev@googlegroups.com, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] CS5535: Remove the X86 platform dependence of SND_CS5535AUDIO
Date: Fri,  9 Oct 2009 11:44:02 +0800
Message-Id: <1255059842-12160-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no platform dependence of SND_CS5535AUDIO before 2.6.31, Not
sure who have touched this part, but SND_CS5535AUDIO is at least
available on Loongson family machines, so, Remove the platform
dependence directly.

Reported-by: rixed@happyleptic.org
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


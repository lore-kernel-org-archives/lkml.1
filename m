Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbZJOCXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbZJOCXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932546AbZJOCXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:23:42 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:37894 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbZJOCXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=LL6ee+Rmi7H34F85yPZsUMhQfwNP7HtHiv/EB/0rO4bs8RsYwZMCHOm/t0h9ma8+jF
         ubPQiLT7WQ8q3//lQ2QrOFOzdkGVfTF32vLHHhkXgkihS7pI2+qiDC6afhwseYS0F8DR
         hPSiu8i2LwtnrJ/8cl9Gs/hJAKif/2bSrOP8I=
Subject: [PATCH] SND_CS5535AUDIO: Remove the X86 platform dependency
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>, loongson-dev@googlegroups.com
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       linux-sound@vger.kernel.org
In-Reply-To: <1255190029-17584-1-git-send-email-wuzhangjin@gmail.com>
References: <1255190029-17584-1-git-send-email-wuzhangjin@gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 15 Oct 2009 10:22:54 +0800
Message-Id: <1255573374.7638.22.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CC to: Takashi Iwai <tiwai@suse.de>, linux-sound@vger.kernel.org

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



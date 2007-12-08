Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXLHUx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXLHUx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXLHUxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:53:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:50791 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbXLHUxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=IF7LW1z04725896/M+aa0lI+8MLD2soYlghXsU62QLOE11bErZCY5u612U64CPBEFs8yZUiKIw44OzXrzEY8Q9Z45MnxUn+JIj8biy1OkuRZ7e30lBn83CuaOHys5lTAFzagg5IKSejfPepeXh2JNFH3D2ou8uZanrxHpk5miFM=
Date: Sat, 8 Dec 2007 21:54:52 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sound/core/memory.c: include sound/core.h
Message-ID: <20071208205448.GH5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/core/memory.c: include sound/core.h

copy_to_user_fromio and copy_from_user_toio are declared in sound/core.h
but sound/core/memory.c doesn't include it - fix it

depends on: "[PATCH] sound/core.h: include sound/driver.h"

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/core/memory.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/core/memory.c b/sound/core/memory.c
index 25b0f05..0420056 100644
--- a/sound/core/memory.c
+++ b/sound/core/memory.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
+#include <sound/core.h>

 /**
  * copy_to_user_fromio - copy data from mmio-space to user-space

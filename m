Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXLHUuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXLHUuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXLHUtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:49:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:46287 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXLHUtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=EzI1t58gU+XTnZCdyQdXYwN3qpFZ9nGEI7XI4nXekXhDem39lYr9qwNcV45tT36TnZtfARfQpRRTmE3XYnC/7Teq959K1GGUOAXsA7EhGHJ5Ycn7WOhi3O/4mngZRlyNEs355l4bquv+c9a41QACoA2nSOOOwTMLmVnJoC7HhdA=
Date: Sat, 8 Dec 2007 21:50:45 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sound/core.h: include sound/driver.h
Message-ID: <20071208205040.GG5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/core.h: include sound/driver.h

include sound/driver.h in sound/core.h because core.h
uses SNDRV_CARDS (which is defined in sound/driver.h)

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 include/sound/core.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 6954836..3b0903a 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -27,6 +27,7 @@
 #include <linux/rwsem.h>		/* struct rw_semaphore */
 #include <linux/pm.h>			/* pm_message_t */
 #include <linux/device.h>
+#include <sound/driver.h>

 /* forward declarations */
 #ifdef CONFIG_PCI

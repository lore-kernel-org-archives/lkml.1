Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYKYPZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYKYPZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKYPY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:24:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:14072 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYKYPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=a+K96c9MDDQOIN6mJp3yzmJVPM3T0tbtvoYnoB/TNGEAxXowZzF2nz8QmOJHZOg2Ga
         IstzCr1lW9fm7tzhLZq83k7awa7b3XO2giSa0i3llfGufxZtBT2jVgM35c2KaHZuOzz2
         XcED7/n6FrSjNXthLI3zyoWGBdeCwAVAZmn4Y=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       alsa-devel@alsa-project.org
Subject: [PATCH 1/2] sound/pci/hda/hda_codec.c: cleanup kernel-doc
Date: Tue, 25 Nov 2008 23:24:49 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492c18c6.011e6e0a.0d83.7b0b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no argument named @state in snd_hda_resume,
remove its' comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index ba1ab73..979f34a 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3109,7 +3109,6 @@ int snd_hda_suspend(struct hda_bus *bus, pm_message_t state)
 /**
  * snd_hda_resume - resume the codecs
  * @bus: the HDA bus
- * @state: resume state
  *
  * Returns 0 if successful.
  *


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYB2ASj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYB2ASj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYB2ASN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:18:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:65407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYB2ASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ICNSmlLQN8ED15kXokwdIi4WiYXQaTHRbcNt7/4hBjyztUSUfNCe0y8C24pRMDormlkohbqGe4cPInPecjmlxvk+eSYOmViZZ+TNUCHOS1caJBRD6FSZiBVHSTYrtlTcIChqi9V4REMcc/jJ5E+TvmzQrfeKmzYHTtm2kvcpGv0=
Subject: [PATCH 3/3] sound: vmaster.c missing include of hda_local.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:18:11 -0800
Message-Id: <1204244291.20280.104.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for the two prototypes, must include hda_codec.h as well
due to some dependencies between the headers.
sound/pci/hda/vmaster.c:230:5: warning: symbol 'snd_ctl_add_slave' was not declared. Should it be static?
sound/pci/hda/vmaster.c:329:21: warning: symbol 'snd_ctl_make_virtual_master' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/hda/vmaster.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/vmaster.c b/sound/pci/hda/vmaster.c
index 2da49d2..26149b5 100644
--- a/sound/pci/hda/vmaster.c
+++ b/sound/pci/hda/vmaster.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/control.h>
+#include "hda_codec.h"
+#include "hda_local.h"
 
 /*
  * a subset of information returned via ctl info callback
-- 
1.5.4.3.342.g99e8


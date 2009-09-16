Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZIPVkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZIPVkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbZIPVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:39:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972AbZIPVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KWv3/vz9AeVq5yduc7FyU8qlHhTx/BYKuIPt8Te85fqvKu6o+wLxXY8uhFn4eAS7RG
         i+6KOVNh38Mnw64I6jF9DUT1sHbQ+xX2R8RkU0j6mkPH/j76xzUW5MtGrtNmMHHb/t4M
         TIPPB2CaKzN0zCE6gPZpHcbDi6VzrLXYAr74A=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2 3/6] kbuild: mkcompile_h: trivial cleanups
Date: Thu, 17 Sep 2009 00:38:40 +0300
Message-Id: <1253137123-18047-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UTS_TRUNCATTE is simpler this way, and now editors idetify this as a
shell script.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 scripts/mkcompile_h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index f060763..bce3d0f 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -1,3 +1,5 @@
+#!/bin/sh
+
 TARGET=$1
 ARCH=$2
 SMP=$3
@@ -50,7 +52,7 @@ UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS $TIMESTAMP"
 # Truncate to maximum length
 
 UTS_LEN=64
-UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}\).*/\1/"
+UTS_TRUNCATE="cut -b -$UTS_LEN"
 
 # Generate a temporary compile.h
 
-- 
1.6.5.rc1


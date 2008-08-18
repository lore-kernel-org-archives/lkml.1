Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYHRUiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYHRUiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYHRUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:38:06 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:39506 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYHRUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WUxEdvGGruYdBqMqWGRiMnvKNMDkkLaoKz6S0o1wBImII77oir4ZdAtLNMtiZyrUG+
         QqB3wdjfIp+4+2wJtIePFbMebILX/oSeVQh+ZRPTS9JbHjEiVqRrO192UvcrP9QPNbIN
         bLqJoBV+DRNyMJ4bXGLQ66NBRmeNWuK1P3bpg=
Subject: [PATCH 1/2] byteorder: add new headers for make headers-install
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 13:38:00 -0700
Message-Id: <1219091880.23637.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, two fixes before the arches start moving over.

 include/linux/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 7d97067..0ffee42 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -179,6 +179,7 @@ unifdef-y += audit.h
 unifdef-y += auto_fs.h
 unifdef-y += auxvec.h
 unifdef-y += binfmts.h
+unifdef-y += byteorder.h
 unifdef-y += capability.h
 unifdef-y += capi.h
 unifdef-y += cciss_ioctl.h
@@ -335,6 +336,7 @@ unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
 unifdef-y += string.h
+unifdef-y += swab.h
 unifdef-y += synclink.h
 unifdef-y += sysctl.h
 unifdef-y += tcp.h
-- 
1.6.0.274.g8aacc



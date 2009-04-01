Return-Path: <linux-kernel-owner+w=401wt.eu-S1765414AbZDANdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765414AbZDANdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763400AbZDANdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:33:04 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:62587 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761967AbZDANdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:33:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=g6VRmXcLHiY80BVf1h3pLtAIECozFbyuFOLffsBrda0JA9U+nb+bTC97X7zL8uoPGE
         366k95x+iOWGfSdNnmRpmt6pa2N+NwbLQKmxB53/qsab4w5+5Dl6sQyz0qOSGu0XuDA1
         Jbwa9GK9kU6iFObqsUYo9WF+Voq7XKLcxZRVs=
MIME-Version: 1.0
Date: Wed, 1 Apr 2009 17:32:58 +0400
Message-ID: <a4423d670904010632h35a20b8er8003578b5075189d@mail.gmail.com>
Subject: [PATCH] befs: fix build on parisc
From: Alexander Beregalov <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, rathamahata@php4.ru,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error on parisc:
fs/befs/super.c:85: error: 'PAGE_SIZE' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/befs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/befs/super.c b/fs/befs/super.c
index 41f2b4d..ca40f82 100644
--- a/fs/befs/super.c
+++ b/fs/befs/super.c
@@ -8,6 +8,7 @@
  */

 #include <linux/fs.h>
+#include <asm/page.h> /* for PAGE_SIZE */

 #include "befs.h"
 #include "super.h"

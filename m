Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbZANW7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbZANW7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZANW7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:59:44 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:45686 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZANW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=Ikk3xBcOY0vCFgHA3QaHf3LbylVU81VcUR97zQEAVI2bBaBi9iOMsEYKIHz7YUhlG8
         G6/UN+9yFnLNVQ//DunYCEQCRZ7NS4fcLQo0BgVwRNcMwOwN7gIQux8nwjUrKdhe0S+E
         ve9eP0+bi0UZVghdpl9fSfJuCPbyOD3hrw3Nk=
Date: Thu, 15 Jan 2009 06:59:43 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: chris.mason@oracle.com
Subject: Btrfs: remove duplicated #include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090115065753.1F16.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include "compat.h"in
fs/btrfs/extent-tree.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 293da65..cc45ec0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -30,7 +30,6 @@
 #include "volumes.h"
 #include "locking.h"
 #include "ref-cache.h"
-#include "compat.h"

 #define PENDING_EXTENT_INSERT 0
 #define PENDING_EXTENT_DELETE 1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYJHGig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYJHGig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYJHGi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:38:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:41681 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYJHGi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=od6N34eUXYcVHmufXwC6PxRmjt2PC2Ot0goezpiaENNoDmbml+B8692l5fs/AHKQ2k
         kJ5QCqn6Y5to16a+Hbr4h3RktQ+3wLXDS3W+PZFWKfDTg+sKzpKOBSChnhfbbHveOfk3
         sS8lG/OzXjiykCcb84p+eYgHO3Ncf/IoDZkVg=
Subject: [PATCH 1/4] h8300: Change unaligned access to use packed struct
 implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 23:38:22 -0700
Message-Id: <1223447903.8195.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
There are only 3 arches that use the memmove-based implementation, there
doesn't seem to be any obvious reason not to use the struct implementation.

Yoshinori?

 arch/h8300/include/asm/unaligned.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/include/asm/unaligned.h b/arch/h8300/include/asm/unaligned.h
index b8d06c7..ab851e7 100644
--- a/arch/h8300/include/asm/unaligned.h
+++ b/arch/h8300/include/asm/unaligned.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_H8300_UNALIGNED_H
 #define _ASM_H8300_UNALIGNED_H
 
-#include <linux/unaligned/be_memmove.h>
+#include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
 
-- 
1.6.0.2.471.g47a76



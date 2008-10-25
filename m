Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYJYDev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYJYDev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYJYDcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:32:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:19879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYJYDaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wbf0XXCfDKCJNgxFxOEd85hDPWM7sdo4ZYp/+btXgIMa6YeFcIl/WjBtHG6lIz/uht
         /mrhlOLjrifN1IprnPr7+AMZyd6uz81mFI7TUJdlOe0saRPRu7+wbBHd1epBLkJIRHr+
         wbwwGmiwDD4KN0lvj7rZd9oTIQtg3derIfq7U=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 02/12] x86: Use new gate_struct for gate_desc
Date: Fri, 24 Oct 2008 20:15:22 -0700
Message-Id: <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
References: <>
 <1224904532-9586-1-git-send-email-ice799@gmail.com>
 <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
In-Reply-To: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
References: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the gate_desc typedef to use the new gate_struct.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 include/asm-x86/desc_defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index 68abda4..012df1f 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -72,7 +72,7 @@ typedef struct ldttss_desc64 tss_desc;
 #define gate_offset(g) ((g).offset_low | ((unsigned long)(g).offset_middle << 16) | ((unsigned long)(g).offset_high << 32))
 #define gate_segment(g) ((g).segment)
 #else
-typedef struct desc_struct gate_desc;
+typedef struct gate_struct gate_desc;
 typedef struct desc_struct ldt_desc;
 typedef struct desc_struct tss_desc;
 #define gate_offset(g)		(((g).b & 0xffff0000) | ((g).a & 0x0000ffff))
-- 
1.5.4.3


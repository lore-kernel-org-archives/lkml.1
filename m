Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbZCUFvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbZCUFvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbZCUFto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:49:44 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:58102 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761525AbZCUFtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PAjB4TQv3yP7dtXtiHFKsLntx0c/Z6pQG2sfpR2MVw3a6rjDCJfxDvHvDdEzHWXlDg
         VR/uedcsa5giG9erA2cL1j4A88b1BcovMe71haR5JqszguyaVknjvSTUcK4aXKXXvJXw
         fo0eDA4uKNqe9Vvcxs+1dGRXRzLL6JqQM70As=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] tracing, x86: remove duplicated #include
Date: Sat, 21 Mar 2009 13:49:36 +0800
Message-Id: <1237614576-2592-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include in arch/x86/kernel/ftrace.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/ftrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 231bdd3..1829b28 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -19,7 +19,6 @@
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
-#include <linux/ftrace.h>
 #include <asm/nops.h>
 #include <asm/nmi.h>
 
-- 
1.6.0.4


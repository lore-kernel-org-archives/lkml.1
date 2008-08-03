Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbYHCQw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbYHCQw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 12:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYHCQwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 12:52:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:34480 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbYHCQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 12:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=P2/8nZ5vwCNw7/MbLZIWHb+j3K9m0AUAclxxzyC4ZKyM9mSHsNLBCjToDI5q5toGr1
         OQnlkcZ0kpjh3vWsKML8n6IbiK82tNms4PscRUBN7CrcIIhdXeYQCqVn57mZTJy7R6lS
         89nabDZ0k1bQ5P9HvkXAAFSv1V9J5osFImYmE=
Date: Sun, 3 Aug 2008 18:52:14 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Glauber Costa <gcosta@redhat.com>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86, acpi: temp_stack is used only when CONFIG_SMP is set
Message-ID: <20080803165210.GC5414@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/acpi/sleep.c:24: warning: 'temp_stack' defined but not used

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Glauber Costa <gcosta@redhat.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/sleep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index fa2161d..9103cb6 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -20,7 +20,7 @@ unsigned long acpi_realmode_flags;
 /* address in low memory of the wakeup routine. */
 static unsigned long acpi_realmode;
 
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_SMP
 static char temp_stack[10240];
 #endif
 
-- 
1.5.4.5


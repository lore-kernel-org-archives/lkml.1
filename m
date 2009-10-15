Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZJOGP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZJOGP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZJOGP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:15:26 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:61837 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZJOGPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NeG1M1cJT717dAr8yQ3JyWQLMG9HSdaQNYS3PTK1155v4JuVXntkiRmWu1MpSJTl59
         HwfGnq5ksPmjkj3SLPUBqp1FGEcMyv8MHP8ZznXaF1UsGluN3lSKa0YWF/uLO5pFsGe7
         sAzzqWaXsJsqyoRChMFYwUs2KFSc+/aGTGhOM=
Date: Thu, 15 Oct 2009 10:14:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: [PATCH] tags: add prototypes and external declarations back
Message-ID: <20091015061444.GA5742@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having prototypes in tags is useful for quick lookup which header needs
to be included.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -102,7 +102,7 @@ exuberant()
 	-I ____cacheline_internodealigned_in_smp                \
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
-	--extra=+f --c-kinds=-px                                \
+	--extra=+f --c-kinds=+px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
 

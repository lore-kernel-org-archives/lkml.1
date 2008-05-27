Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYE0QKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYE0QKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYE0QJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:09:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:48709 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbYE0QJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=kMPLGq76mYQWlF5aWOBMpOD59J4xbJMPytV1cZnSYoOyHZt3sxwV8LDvSBiTsjw47xWspuMXJZ9oIppJf4MXM3VhDaLPiSS3gYI/30xM1KMqKfdhU75hyC7ZN1QkS1CVX2GfD4c4UYYgtn9IMAKHNYc/2b8SpVP8tLI0RypmZvU=
Date: Tue, 27 May 2008 18:09:51 +0200
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: fix incomplete header guard
Message-ID: <20080527160951.GC7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 17:28:50 +0200
Subject: [PATCH] parisc: fix incomplete header guard

Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-parisc/psw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-parisc/psw.h b/include/asm-parisc/psw.h
index 5a3e23c..ebc0b4d 100644
--- a/include/asm-parisc/psw.h
+++ b/include/asm-parisc/psw.h
@@ -1,5 +1,5 @@
 #ifndef _PARISC_PSW_H
-
+#define _PARISC_PSW_H
 
 #define	PSW_I	0x00000001
 #define	PSW_D	0x00000002
-- 
1.5.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZBRVdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZBRVdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZBRVdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:33:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:18817 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZBRVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:33:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qxLcnyIu2pOjdgvAbYQwvgAC3od068DjYSRG0lFwycFJwmsErUGX0hPj7u0stlUvPP
         kjZs9YE2jnpOR9t4NVJtTWPZ8AwUbyER40evivJDFq5zZuMZ8TueXRgWO+OD6n02goaC
         zKixGzG90jR/TWVAb7NzR8Qpn2OWba8x0rW8k=
Subject: [RFC PATCH] kernel: add -D__CHECK_ENDIAN__ by default
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 13:33:01 -0800
Message-Id: <1234992781.31073.192.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The noise level with endian checking is getting to the point where
having this enabled by default wouldn't be too bad.  If this were to
go in for the 2.6.30 devel cycle it may motivate the last sections that
are still particularly noisy (sound/, drivers/scsi/ come to mind)

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 96628d0..4d4e400 100644
--- a/Makefile
+++ b/Makefile
@@ -326,7 +326,7 @@ PERL		= perl
 CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
-		  -Wbitwise -Wno-return-void $(CF)
+		  -D__CHECK_ENDIAN__ -Wbitwise -Wno-return-void $(CF)
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
-- 
1.6.2.rc1.175.g96b8a




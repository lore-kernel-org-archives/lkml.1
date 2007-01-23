Return-Path: <linux-kernel-owner+w=401wt.eu-S965436AbXAWTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436AbXAWTez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965432AbXAWTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:34:55 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:33091 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965408AbXAWTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:53 -0500
Message-Id: <200701231927.l0NJRmUb005368@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 7/7] UML - fix style violations
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jan 2007 14:27:48 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bunch of style violations in mem.c.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/mem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/mem.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/mem.c	2007-01-17 13:03:12.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/mem.c	2007-01-17 13:05:21.000000000 +1100
@@ -35,7 +35,8 @@ static void __init find_tempdir(void)
 	int i;
 	char *dir = NULL;
 
-	if(tempdir != NULL) return;	/* We've already been called */
+	if(tempdir != NULL) /* We've already been called */
+		return;
 	for(i = 0; dirs[i]; i++){
 		dir = getenv(dirs[i]);
 		if((dir != NULL) && (*dir != '\0'))
@@ -193,7 +194,7 @@ int make_tempfile(const char *template, 
 	} else {
 		free(tempname);
 	}
-	return(fd);
+	return fd;
 out:
 	free(tempname);
 	return -1;
@@ -238,7 +239,7 @@ int create_tmp_file(unsigned long long l
 		exit(1);
 	}
 
-	return(fd);
+	return fd;
 }
 
 int create_mem_file(unsigned long long len)
@@ -252,7 +253,7 @@ int create_mem_file(unsigned long long l
 		errno = -err;
 		perror("exec_close");
 	}
-	return(fd);
+	return fd;
 }
 
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbXH0XWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbXH0XWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXH0XWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:22:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:45576 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbXH0XWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Knb3QWgEUN9/rT3fDjLCdwphNmT3WT7ApPtZ319RkcO1l4AbEUVEU1nu79LEFeuuYmfBhMFvUl4yuSmafvQnIFz9eHWESMWB/eFR232Z42wxX75PDurFI0TQvhP2/m9cHaSgX50MuphS5hocrp+Pm/R8H1a271YeKr5nB3uUdPs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] Fix tiny compiler warning in smount example program from Documentation/sharedsubtree.txt
Date: Tue, 28 Aug 2007 01:19:43 +0200
User-Agent: KMail/1.9.7
Cc: Ram Pai <linuxram@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280119.44134.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

If one compiles the example smount program, found in 
Documentation/sharedsubtree.txt, with -Wall then there's a small 
compiler warning rearing its ugly head : 

 smount.c: In function 'main':
 smount.c:45: warning: implicit declaration of function 'strcmp'

Easily fixed by just including string.h


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Documentation/sharedsubtree.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/sharedsubtree.txt b/Documentation/sharedsubtree.txt
index ccf1ceb..7365400 100644
--- a/Documentation/sharedsubtree.txt
+++ b/Documentation/sharedsubtree.txt
@@ -153,6 +153,7 @@ replicas continue to be exactly same.
 	#include <stdio.h>
 	#include <stdlib.h>
 	#include <unistd.h>
+	#include <string.h>
 	#include <sys/mount.h>
 	#include <sys/fsuid.h>
 



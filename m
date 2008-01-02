Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYABCuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYABCuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYABCt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:49:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:49041 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYABCt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:49:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JSOvCRRMLe8Ut9cN6v+A2RXLCUHxmPi4QGLKFAvnkl6opuGFMWOg6V+dyj0LTx3paJnBRKnaB5BqGTNLYqTThw9H0UBmMgPXsVG/87QHYu7+oK0bHucUJeyeWgTyVZSrWjT4d9TADdegxS8L8sHUO77Nj9c/aqS1rxdBM0q/rEE=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Nuke duplicate include from printk.c
Date: Wed, 2 Jan 2008 03:44:56 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200801020339.00698.jesper.juhl@gmail.com>
In-Reply-To: <200801020339.00698.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020344.56809.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>


Remove the duplicate inclusion of linux/jiffies.h from kernel/printk.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 printk.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 89011bf..b4bca0d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,7 +32,6 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
-#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 




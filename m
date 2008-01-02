Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYABCuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYABCuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYABCur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:50:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:50477 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYABCuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LKV49FaaQMlKHH3NfFRwbMFJRieV0fQnR9e7nMj5H0ODl4nJXuwJptf3yAeH+UGMtP2SDcGP1YZsulXA0kD5u/WGHwFzq7kemkkjeQYd5Nv7X6EkeV6rCMf6ijdGV5wOIu+WFXwxmoNemV7DpfpektBO8wB1PNhQ262mkf21MoE=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Nuke a duplicate include from profile.c
Date: Wed, 2 Jan 2008 03:45:46 +0100
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
Message-Id: <200801020345.46317.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

Remove duplicate inclusion of linux/profile.h from kernel/profile.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 profile.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 5e95330..ffaebea 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
-#include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
 #include <asm/sections.h>





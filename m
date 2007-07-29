Return-Path: <linux-kernel-owner+w=401wt.eu-S937128AbXG2Vo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937128AbXG2Vo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935724AbXG2Vow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:44:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:3079 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935393AbXG2Vov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rQjMV/eBDTPsSHFTCjEH7AzhYoi1/6uuJrE8YEQxiEKYItnd51EKYGg3ihJQ9JOidP++7WqUAKTmYovWlCBSJxHERFD7R4vpKBhzSUFdLjU7qqjfFI36cyW8+CaZtXRqNChihDVWPbyHvho6i1++XWTISH5h9AGng/A/6L20yqI=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Ian Molton <spyro@f2s.com>
Subject: [PATCH] arm26: remove duplicate include of linux/module.h
Date: Sun, 29 Jul 2007 23:43:18 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292343.18706.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch removes the duplicate inclusion of 
linux/module.h from arm26.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 arch/arm26/kernel/armksyms.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm26/kernel/armksyms.c b/arch/arm26/kernel/armksyms.c
index fe1e3ce..0ddda4d 100644
--- a/arch/arm26/kernel/armksyms.c
+++ b/arch/arm26/kernel/armksyms.c
@@ -8,7 +8,6 @@
  * published by the Free Software Foundation.
  */
 #include <linux/module.h>
-#include <linux/module.h>
 #include <linux/user.h>
 #include <linux/string.h>
 #include <linux/fs.h>



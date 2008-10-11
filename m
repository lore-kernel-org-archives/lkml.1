Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbYJKU6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbYJKU6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYJKU63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:58:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:19971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYJKU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iN/91p19an0d0wB34zPIIbrKZrB8vT2CIwwRxoSshWa8l0218YyF3+CYu54bf0GZDg
         xunsSrgfCHsb4HAbQ+nrQWQkcxLqAqSAGdpoz3RhiRHdAyVKoDAYm5UCflDErlS6d2hc
         IulVrZg6aeatGL+QsFCluObftzsmRzhJDvYQE=
Date: Sun, 12 Oct 2008 00:58:22 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: yhlu.kernel@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/resource: fix printk format warning
Message-ID: <20081011205822.GA25563@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 kernel/resource.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..cfe0933 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -550,8 +550,8 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 	if (!res) {
 		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-			 conflict->name, conflict->start, conflict->end,
-			 name, start, end);
+			 conflict->name, (unsigned long long)conflict->start, (unsigned long long)conflict->end,
+			 name, (unsigned long long)start, (unsigned long long)end);
 
 		/* failed, split and try again */
 

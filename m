Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYJNMny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYJNMny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYJNMnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:43:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:15413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYJNMnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k+SZaNFpRvW2GZbJn1S17QtlqX27uB64PtMA/LmCt+GwuN+CQSrqiBon4zjOytPLfh
         VZv/lAlkOnajC4jUdFGbI0CKicUYRVHHrTbgPvWWq7HN6MSrV2ovPm9cNHUEpu68JFZp
         u3Tk7QSaT1ywvrmyZYx694Gmec/YZ7VNr1MZ8=
Date: Tue, 14 Oct 2008 16:46:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: [PATCH] alpha: notify_cpu_starting() compile fixlet
Message-ID: <20081014124617.GB23968@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/alpha/kernel/smp.c:153: error: implicit declaration of function 'notify_cpu_starting'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -27,6 +27,7 @@
 #include <linux/cache.h>
 #include <linux/profile.h>
 #include <linux/bitops.h>
+#include <linux/cpu.h>
 
 #include <asm/hwrpb.h>
 #include <asm/ptrace.h>

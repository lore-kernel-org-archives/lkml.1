Return-Path: <linux-kernel-owner+w=401wt.eu-S1763097AbZEATyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097AbZEATyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZEATy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:54:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:54996 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZEATy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wbGVS52zLczMRegflQNRMwtRJoI0b7hSIsb6iyR5Y2Bkv6CedTlRQZ8tV4RGkYwQ1E
         0VEjdIi0X0ZFSuukLZGP7DZh9FCKrkcmEx61mt5KGd4Z0Zt7Vg+dUZB+1pJ8Q9pbsuP8
         D7wFBK+YQ1qgfSxkvWSepcFE8QaBkLMd9y5IY=
Date: Fri, 1 May 2009 23:54:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: apic - use pr_ macro
Message-ID: <20090501195425.GB4633@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace recenly appeared printk with pr_ macro
(the file already use a lot of them).

[ Impact: cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -2195,7 +2195,7 @@ static int __cpuinit set_multi(const str
 {
 	if (multi)
 		return 0;
-	printk(KERN_INFO "APIC: %s detected, Multi Chassis\n", d->ident);
+	pr_info("APIC: %s detected, Multi Chassis\n", d->ident);
 	multi = 1;
 	return 0;
 }

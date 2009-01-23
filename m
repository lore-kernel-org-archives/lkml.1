Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbZAWLAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbZAWLAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbZAWLAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:00:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761530AbZAWLAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HTEe5MPNitIWV63rxWwHChV9WtrukPtv94jixcGT0m5MIdH51FhqMXoPwNNL1Go2r/
         hL8SSalkkdpOvbHgeICZvXIAn8xQHH9tjFijPnj4uJ9kwlS6pBxTeDsyyPdaZZrcrYqL
         p+cJVof/QUqJWkiakGrBy4/G2hx0KDnAMSqu0=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, gregkh@suse.de, roel.kluin@gmail.com,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de
Date: Fri, 23 Jan 2009 19:58:00 +0900
Message-Id: <20090123105800.18779.61288.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 003/011] sh: plat_early_device_setup() for sh2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds sh2 code to register early platform devices
using plat_early_device_setup().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh2/setup-sh7619.c |    5 +++++
 1 file changed, 5 insertions(+)

--- 0013/arch/sh/kernel/cpu/sh2/setup-sh7619.c
+++ work/arch/sh/kernel/cpu/sh2/setup-sh7619.c	2009-01-23 17:31:44.000000000 +0900
@@ -149,6 +149,11 @@ static int __init sh7619_devices_setup(v
 }
 __initcall(sh7619_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7619_devices, ARRAY_SIZE(sh7619_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);

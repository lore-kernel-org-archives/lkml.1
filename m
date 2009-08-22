Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbZHVUa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbZHVUa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 16:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbZHVUaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:30:55 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49317 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbZHVUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FXtcAMWTiv5aTZU+/168XM6UlHSxqcbZrTKZtICWhd6decEs6mwadRUWRgQQdrEFPo
         IVddQOG9BGnd9LEO413djLw3t6Vgd94L/+OHgxxSZVLeIOCH2KaP0wAJazvRDi9kEook
         WBe1peHMJX/nb3TYIPQBR/mgszWi8svzkpZSA=
Subject: Subject:[ PATCH 002:003] export cpu up
From: raz ben yehuda <raziebe@gmail.com>
To: riel@redhat.com
Cc: mingo@elte.hu, peterz@infradead.org, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 02:30:59 +0300
Message-Id: <1250983859.5688.27.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export cpu_up for offsched driver use
cpu.c |    1 +
 1 file changed, 1 insertion(+)
Signed-off-by: raziebe@gmail.com
---
--- tmp/linux-2.6.30/kernel/cpu.c	2009-08-22 03:14:42.000000000 +0300
+++ 2.6.30-offsched/kernel/cpu.c	2009-07-25 13:59:19.000000000 +0300
@@ -373,6 +373,7 @@
 	cpu_maps_update_done();
 	return err;
 }
+EXPORT_SYMBOL(cpu_up);
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;



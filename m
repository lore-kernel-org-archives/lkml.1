Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYGIS2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYGIS2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYGIS21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:28:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:29410 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYGIS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=nmYcZ4lzubx5q8bFaEXuakd2XsPhoEeAiF4dlslDtIqDpNhYYFVAn6u+R41jkp+by0
         NkcL7Vphx1Kei8LyAZLyHEXdtqqZuFffmFt8vJd+LZ1bWk9GwVT39ZqkCS2lVwM4XMkX
         LfpquOI3VT0WvQbyulSteTU855QzR4dzI7NRg=
Message-ID: <a4423d670807091128t3a03b739y66fcffcfcf961f8@mail.gmail.com>
Date: Wed, 9 Jul 2008 22:28:24 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: mingo@elte.hu, yhlu.kernel@gmail.com, tglx@linutronix.de, hpa@zytor.com,
       kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] arch/x86/kernel/cpu/common_64.c: remove double inclusions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

x86: remove double inclusions in arch/x86/kernel/cpu/common_64.c


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 7518502..85cf7e1 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -7,12 +7,9 @@
 #include <linux/module.h>
 #include <linux/kgdb.h>
 #include <linux/topology.h>
-#include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/smp.h>
-#include <linux/module.h>
 #include <linux/percpu.h>
-#include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
 #include <asm/io.h>

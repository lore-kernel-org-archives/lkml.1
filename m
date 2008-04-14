Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbYDNOW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbYDNOW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbYDNOUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:20:48 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41934 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761488AbYDNOUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:20:47 -0400
Date: Mon, 14 Apr 2008 17:19:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] powerpc/sysdev/rtc_cmos_setup.c: add MODULE_LICENSE
Message-ID: <20080414141942.GL6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6f9e3869ba8122adefb706c7d5c18cf4b2dc65c9 diff --git a/arch/powerpc/sysdev/rtc_cmos_setup.c b/arch/powerpc/sysdev/rtc_cmos_setup.c
index 0c9ac7e..c09ddc0 100644
--- a/arch/powerpc/sysdev/rtc_cmos_setup.c
+++ b/arch/powerpc/sysdev/rtc_cmos_setup.c
@@ -56,3 +56,5 @@ static int  __init add_rtc(void)
 	return 0;
 }
 fs_initcall(add_rtc);
+
+MODULE_LICENSE("GPL");


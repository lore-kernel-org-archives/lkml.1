Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXKSG0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXKSG0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 01:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXKSG0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 01:26:24 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:33553 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbXKSG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 01:26:23 -0500
Date: Mon, 19 Nov 2007 11:56:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org, anton@au1.ibm.com, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH-RESEND] 2.6.24-rc2-mm1 powerpc (iseries)- build failure - mm/stab.c
Message-ID: <20071119062611.GA11135@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20071114105410.GA16846@linux.vnet.ibm.com> <20071119133849.bcfe52c1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119133849.bcfe52c1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Resubmitting the patch titled 
powerpc-iseries-build-failure-mm-stabc.patch in the -mm tree.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc2/arch/powerpc/mm/stab.c	2007-11-07 03:27:46.000000000 +0530
+++ linux-2.6.24-rc2/arch/powerpc/mm/~stab.c	2007-11-19 19:43:55.000000000 +0530
@@ -20,6 +20,7 @@
 #include <asm/lmb.h>
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
+#include <asm/iseries/hv_call.h>
 
 struct stab_entry {
 	unsigned long esid_data;

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

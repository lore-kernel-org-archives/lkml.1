Return-Path: <linux-kernel-owner+w=401wt.eu-S965575AbXBTACI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965575AbXBTACI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965574AbXBTACI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:02:08 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35982 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965573AbXBTACF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:02:05 -0500
Date: Tue, 20 Feb 2007 01:02:03 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: [-mm patch] make struct vmi_ops static
Message-ID: <20070220000203.GW13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct vmi_ops static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm1/arch/i386/kernel/vmi.c.old	2007-02-16 14:26:50.000000000 +0100
+++ linux-2.6.20-mm1/arch/i386/kernel/vmi.c	2007-02-16 14:27:00.000000000 +0100
@@ -56,7 +56,7 @@
 static int disable_mtrr;
 
 /* Cached VMI operations */
-struct {
+static struct {
 	void (*cpuid)(void /* non-c */);
 	void (*_set_ldt)(u32 selector);
 	void (*set_tr)(u32 selector);


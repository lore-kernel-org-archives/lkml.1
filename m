Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYI2WCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYI2WCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYI2WC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:02:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39911 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbYI2WC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:02:28 -0400
Date: Mon, 29 Sep 2008 17:02:28 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/4] Add EFI OEM runtime services entry
Message-ID: <20080929220228.GC108640@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] Add EFI OEM runtime services entry

Add oem runtime services function pointer.

Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>

---
 include/linux/efi.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/linux/efi.h
===================================================================
--- linux.orig/include/linux/efi.h	2008-09-29 15:20:53.000000000 -0500
+++ linux/include/linux/efi.h	2008-09-29 15:20:59.000000000 -0500
@@ -156,6 +156,7 @@ typedef struct {
 	unsigned long set_variable;
 	unsigned long get_next_high_mono_count;
 	unsigned long reset_system;
+	unsigned long oem;
 } efi_runtime_services_t;
 
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

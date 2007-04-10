Return-Path: <linux-kernel-owner+w=401wt.eu-S1161020AbXDJW7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbXDJW7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161010AbXDJW7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:59:00 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:51396 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161001AbXDJW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:58:59 -0400
Date: Tue, 10 Apr 2007 18:58:57 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-x86_64
Message-ID: <20070410225857.GA7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:58:09 up 67 days, 13:05,  6 users,  load average: 7.38, 4.53, 2.81
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to x86_64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -59,6 +59,7 @@ SECTIONS
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	} :data
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

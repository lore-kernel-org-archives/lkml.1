Return-Path: <linux-kernel-owner+w=401wt.eu-S1030720AbXDJWkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030720AbXDJWkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030722AbXDJWkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:40:16 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:60661 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030616AbXDJWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:40:13 -0400
Date: Tue, 10 Apr 2007 18:40:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-arm26
Message-ID: <20070410224012.GF7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:39:19 up 67 days, 12:46,  6 users,  load average: 1.55, 1.41, 1.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to arm26.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26-xip.lds.in
@@ -112,6 +112,7 @@ SECTIONS
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		*(.init.data)
--- a/arch/arm26/kernel/vmlinux-arm26.lds.in
+++ b/arch/arm26/kernel/vmlinux-arm26.lds.in
@@ -107,6 +107,7 @@ SECTIONS
 		 * and the usual data section
 		 */
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

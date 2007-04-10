Return-Path: <linux-kernel-owner+w=401wt.eu-S1030654AbXDJWlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030654AbXDJWlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXDJWlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:41:01 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:60757 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030654AbXDJWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:40:59 -0400
Date: Tue, 10 Apr 2007 18:40:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-avr32
Message-ID: <20070410224058.GG7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:40:14 up 67 days, 12:47,  6 users,  load average: 1.22, 1.34, 1.39
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to avr32.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/avr32/kernel/vmlinux.lds.c
+++ b/arch/avr32/kernel/vmlinux.lds.c
@@ -107,6 +107,7 @@ SECTIONS
 		/* And the rest... */
 		*(.data.rel*)
 		*(.data)
+		EXTRA_RWDATA
 		CONSTRUCTORS
 
 		_edata = .;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

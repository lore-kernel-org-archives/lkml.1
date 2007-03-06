Return-Path: <linux-kernel-owner+w=401wt.eu-S933874AbXCFMz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbXCFMz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933915AbXCFMz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:55:28 -0500
Received: from ozlabs.org ([203.10.76.45]:56223 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933874AbXCFMz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:55:27 -0500
Subject: [PATCH 2/8] Remove NR_CPUS from asm-generic/percpu.h
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173185592.4644.28.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:54:26 +1100
Message-Id: <1173185666.4644.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I managed to get an error about NR_CPUS undefined after a make
allyesconfig.  Admittedly this was a patched kernel, but it's easy to
remove it and avoid the error in future even if it's OK at the moment.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 4519e3475c4f include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h	Mon Mar 05 12:17:10 2007 +1100
+++ b/include/asm-generic/percpu.h	Mon Mar 05 16:14:05 2007 +1100
@@ -5,7 +5,7 @@
 #define __GENERIC_PER_CPU
 #ifdef CONFIG_SMP
 
-extern unsigned long __per_cpu_offset[NR_CPUS];
+extern unsigned long __per_cpu_offset[];
 
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 



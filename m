Return-Path: <linux-kernel-owner+w=401wt.eu-S965648AbXBGGww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbXBGGww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965653AbXBGGww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:52:52 -0500
Received: from koto.vergenet.net ([210.128.90.7]:56745 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965648AbXBGGwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:52:51 -0500
Date: Wed, 7 Feb 2007 15:49:36 +0900
From: Horms <horms@verge.net.au>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       fastboot@lists.osdl.org
Cc: Zou Nan hai <nanhai.zou@intel.com>, Khalid Aziz <khalid_aziz@hp.com>,
       Adrian Bunk <trivial@kernel.org>, Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] [IA64] Include kexec.h in arch/ia64/kernel/process.c
Message-ID: <20070207064935.GB726@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kexec.h is needed by arch/ia64/kernel/process.c so for the
declaration of kexec_disable_iosapic() which is used in machine_shutdown().

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/arch/ia64/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/process.c	2007-02-07 12:43:09.000000000 +0900
+++ linux-2.6/arch/ia64/kernel/process.c	2007-02-07 12:43:16.000000000 +0900
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 #include <asm/unwind.h>
 #include <asm/user.h>
+#include <asm/kexec.h>
 
 #include "entry.h"
 

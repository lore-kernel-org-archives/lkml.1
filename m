Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYKGSpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYKGSpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKGSoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:44:55 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:27565 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYKGSoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:44:54 -0500
Date: Fri, 7 Nov 2008 10:43:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: fix kernel-doc syntax
Message-Id: <20081107104302.61907219.randy.dunlap@oracle.com>
In-Reply-To: <20081028084407.GA7913@flint.arm.linux.org.uk>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
	<20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
	<20081015113923.GA21756@flint.arm.linux.org.uk>
	<200810250001.04835.rjw@sisk.pl>
	<20081026184108.GB1847@ucw.cz>
	<20081027092512.9327b690.randy.dunlap@oracle.com>
	<20081027234246.ea5e3b8e.akpm@linux-foundation.org>
	<20081028084407.GA7913@flint.arm.linux.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49148C57.007A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation to use correct syntax.
Even though this should be moved to where the function is
actually implemented...

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/arm/mach-pxa/include/mach/reset.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-next-20081107.orig/arch/arm/mach-pxa/include/mach/reset.h
+++ linux-next-20081107/arch/arm/mach-pxa/include/mach/reset.h
@@ -12,9 +12,8 @@ extern void clear_reset_status(unsigned 
 
 /**
  * init_gpio_reset() - register GPIO as reset generator
- *
- * @gpio - gpio nr
- * @output - set gpio as out/low instead of input during normal work
+ * @gpio: gpio nr
+ * @output: set gpio as out/low instead of input during normal work
  */
 extern int init_gpio_reset(int gpio, int output);
 

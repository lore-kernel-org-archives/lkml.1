Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXCZKLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXCZKLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbXCZKLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:11:43 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:31533 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXCZKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:11:42 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="32577270:sNHT21007392"
Subject: [PATCH -mm] Blackfin arch: fix compiling error in flat c file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:12:10 +0800
Message-Id: <1174903930.32691.68.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

THis patch fixed including wrong header file when compiling in
2.6.21-rc4-mm.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---

 arch/blackfin/kernel/flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/blackfin/kernel/flat.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/flat.c
+++ linux-2.6/arch/blackfin/kernel/flat.c
@@ -18,8 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/flat.h>
 
 #define FLAT_BFIN_RELOC_TYPE_16_BIT 0
_

Thanks,
-Bryan

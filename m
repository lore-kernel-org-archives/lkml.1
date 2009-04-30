Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbZD3Rqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbZD3Rqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764746AbZD3RIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:49 -0400
Received: from kroah.org ([198.145.64.141]:57011 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764691AbZD3RIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:50 2009
Message-Id: <20090430165750.750784732@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:57:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yu Zhao <yu.zhao@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 84/88] PCI: fix incorrect mask of PM No_Soft_Reset bit
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=pci-fix-incorrect-mask-of-pm-no_soft_reset-bit.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yu Zhao <yu.zhao@intel.com>

commit 998dd7c719f62dcfa91d7bf7f4eb9c160e03d817 upstream.

Reviewed-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/pci_regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -234,7 +234,7 @@
 #define  PCI_PM_CAP_PME_SHIFT	11	/* Start of the PME Mask in PMC */
 #define PCI_PM_CTRL		4	/* PM control and status register */
 #define  PCI_PM_CTRL_STATE_MASK	0x0003	/* Current power state (D0 to D3) */
-#define  PCI_PM_CTRL_NO_SOFT_RESET	0x0004	/* No reset for D3hot->D0 */
+#define  PCI_PM_CTRL_NO_SOFT_RESET	0x0008	/* No reset for D3hot->D0 */
 #define  PCI_PM_CTRL_PME_ENABLE	0x0100	/* PME pin enable */
 #define  PCI_PM_CTRL_DATA_SEL_MASK	0x1e00	/* Data select (??) */
 #define  PCI_PM_CTRL_DATA_SCALE_MASK	0x6000	/* Data scale (??) */



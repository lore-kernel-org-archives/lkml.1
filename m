Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZBDS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZBDS4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbZBDStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:21 -0500
Received: from kroah.org ([198.145.64.141]:60931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758589AbZBDStN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:13 -0500
Date: Wed, 4 Feb 2009 10:46:16 -0800
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
       alan@lxorguk.ukuu.org.uk, Seth Heasley <seth.heasley@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 14/41] PCI: irq and pci_ids patch for Intel Tigerpoint
	DeviceIDs
Message-ID: <20090204184616.GO25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-irq-and-pci_ids-patch-for-intel-tigerpoint-deviceids.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 57064d213d2e44654d4f13c66df135b5e7389a26 upstream.

This patch adds the Intel Tigerpoint LPC Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/irq.c      |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -573,6 +573,7 @@ static __init int intel_router_probe(str
 	case PCI_DEVICE_ID_INTEL_ICH7_1:
 	case PCI_DEVICE_ID_INTEL_ICH7_30:
 	case PCI_DEVICE_ID_INTEL_ICH7_31:
+	case PCI_DEVICE_ID_INTEL_TGP_LPC:
 	case PCI_DEVICE_ID_INTEL_ESB2_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_0:
 	case PCI_DEVICE_ID_INTEL_ICH8_1:
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2384,6 +2384,7 @@
 #define PCI_DEVICE_ID_INTEL_ICH7_0	0x27b8
 #define PCI_DEVICE_ID_INTEL_ICH7_1	0x27b9
 #define PCI_DEVICE_ID_INTEL_ICH7_30	0x27b0
+#define PCI_DEVICE_ID_INTEL_TGP_LPC	0x27bc
 #define PCI_DEVICE_ID_INTEL_ICH7_31	0x27bd
 #define PCI_DEVICE_ID_INTEL_ICH7_17	0x27da
 #define PCI_DEVICE_ID_INTEL_ICH7_19	0x27dd


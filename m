Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZDFPpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZDFPpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZDFPpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:45:33 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39336 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDFPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YRO0+1y31ox7F0rgys4UXmnixVkLKSarMlv8met/DIRroA3p8CX8FBcjOP5bDtgg3t
         +FqnE41AD3E99Vt7lI+9TyeyvSDnhyTtwfSA6PqETwe8+Vw2XnH2+Sj7ut5LfPQGOqE3
         JZ1a43PafVCKMAXOO5sxk6fNgIOmJBQVelLcE=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 19:45:28 +0400
Message-ID: <a4423d670904060845l55064a5boc5d869a9d1ae26a7@mail.gmail.com>
Subject: [PATCH next] pci/intr_remapping.c should include acpi.h
From: Alexander Beregalov <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
drivers/pci/intr_remapping.c: In function 'ir_parse_ioapic_scope':
drivers/pci/intr_remapping.c:617: error: invalid use of undefined type
'struct acpi_dmar_hardware_unit'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/pci/intr_remapping.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 472be1c..f5e0ea7 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -9,6 +9,7 @@
 #include <asm/cpu.h>
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
+#include <acpi/acpi.h>

 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;

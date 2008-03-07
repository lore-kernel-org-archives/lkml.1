Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbYCGVHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbYCGVHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbYCGVFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:05:53 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:7175 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857AbYCGVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NpfCFkddszwao2JnFmW/V3Riq2JmmaLSjil85n/BYu/ep4Ebd+XMtbe8TYXRIGd/bkau4tM7p44zhBfyMuYDES9ph5GrxyN67cLwG5ln9/38HeNwuW/ezKeac0L3DygzaCcFsOaJtBmexDDKQArHovhSmtQR9qpa0Eu2gUSS4h4=
Message-ID: <7c86c4470803071305x6b575dxa9f7b0588abfd4b@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:05:50 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perfmon x86 infra(take 2): add AMD Northbridge PCI Id
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ak@suse.de,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       "Robert Richter" <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds AMD Northbridge PCI Id

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -497,6 +497,8 @@
 #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP        0x1101
 #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL 0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC   0x1103
+#define PCI_DEVICE_ID_AMD_10H_NB       0x1200
+#define PCI_DEVICE_ID_AMD_10H_NB_MISC  0x1203
 #define PCI_DEVICE_ID_AMD_LANCE                0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME   0x2001
 #define PCI_DEVICE_ID_AMD_SCSI         0x2020

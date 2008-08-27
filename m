Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYH0Xjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYH0Xjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbYH0Xjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:39:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:40060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbYH0Xja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,283,1217833200"; 
   d="scan'208";a="374227992"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: "Heasley, Seth" <seth.heasley@intel.com>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "htejun@gmail.com" <htejun@gmail.com>
Date: Wed, 27 Aug 2008 16:39:19 -0700
Subject: RE: [PATCH 2.6.26.7-rc4] ata_piix: IDE Mode SATA patch for Intel
 Ibex Peak DeviceIDs
Thread-Topic: [PATCH 2.6.26.7-rc4] ata_piix: IDE Mode SATA patch for Intel
 Ibex Peak DeviceIDs
Thread-Index: AckInYEpQ5UPcwlLQFygc/8T5861AgAAGHQg
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF177A1450@orsmsx501.amr.corp.intel.com>
References: <200808271640.06762.seth.heasley@intel.com>
In-Reply-To: <200808271640.06762.seth.heasley@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Heasley, Seth
>Sent: Wednesday, August 27, 2008 4:40 PM
>To: jgarzik@pobox.com; linux-ide@vger.kernel.org; linux-
>kernel@vger.kernel.org; htejun@gmail.com
>Cc: Heasley, Seth
>Subject: [PATCH 2.6.26.7-rc4] ata_piix: IDE Mode SATA patch for Intel Ibex
>Peak DeviceIDs
>
>This patch updates the Intel Ibex Peak (PCH) IDE mode SATA Controller
>DeviceIDs.
>
>Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>
>--- linux-2.6/drivers/ata/ata_piix.c.orig       2008-08-27
>11:32:28.000000000 -0700
>+++ linux-2.6/drivers/ata/ata_piix.c    2008-08-27 11:47:59.000000000 -0700
>@@ -278,12 +278,15 @@
>        /* SATA Controller IDE (PCH) */
>        { 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>        /* SATA Controller IDE (PCH) */
>+       { 0x8086, 0x3b21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>+       /* SATA Controller IDE (PCH) */
>        { 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>        /* SATA Controller IDE (PCH) */
>+       { 0x8086, 0x3b28, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>+       /* SATA Controller IDE (PCH) */
>        { 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>        /* SATA Controller IDE (PCH) */
>        { 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>-
>        { }     /* terminate list */
> };

Typo in the subject line.  Should read 2.6.27-rc4.  This was built against http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

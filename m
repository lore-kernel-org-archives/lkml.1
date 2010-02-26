Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab0BZXXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:23:14 -0500
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:12479 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524Ab0BZXXM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:23:12 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 18:23:12 EST
X-SpamScore: -11
X-BigFish: VPS-11(zz14ffO4015Lzz1202hzzz2dh6bh65h)
X-Spam-TCS-SCL: 4:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Proposal to move PCI out of arch/powerpc and into drivers/of
Date: Fri, 26 Feb 2010 16:07:59 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Proposal to move PCI out of arch/powerpc and into drivers/of
Thread-Index: Acq3OIoWmC501bknR7q8jY/fGTrqrQ==
From: John Linn <John.Linn@xilinx.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@ozlabs.org>,
       <linuxppc-dev@ozlabs.org>, <microblaze-uclinux@itee.uq.edu.au>
CC: <grant.likely@secretlab.ca>, "John Williams" <john.williams@petalogix.com>,
       <michal.simek@petalogix.com>, <benh@kernel.crashing.org>
X-OriginalArrivalTime: 26 Feb 2010 23:08:01.0215 (UTC) FILETIME=[8B08ECF0:01CAB738]
X-RCIS-Action: ALLOW
Message-ID: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local>
X-Reverse-DNS: unknown-60-83.xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We are in the process of putting PCI/PCIe into the microblaze
architecture.  

In order to not duplicate/fork the PCI code in Powerpc, we're proposing
to move the PCI code from arch/powerpc into drivers/of such that it
would be common code for Powerpc and MicroBlaze.

This would be the 1st part of a refactoring that would occur with the
PCI code.

Ben H., would you mind if that happened (move arch/powerpc/kernel/pci*
to drivers/of/*)?

Thanks,
John

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



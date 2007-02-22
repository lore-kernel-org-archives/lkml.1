Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbXBVK5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbXBVK5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXBVK5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:57:39 -0500
Received: from cnxtsmtp5.conexant.com ([198.62.9.40]:33581 "EHLO
	cnxtsmtp5.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXBVK5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:57:38 -0500
X-Greylist: delayed 2014 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 05:57:38 EST
X-WSS-ID: 0JDV0YH-02-QU8-02
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: PCI buffer allocation in Linux device
Date: Thu, 22 Feb 2007 15:53:59 +0530
Message-ID: <1DF8CECB8B125247ADB23FC01CC3570E2D07F9@NOIDA-MAIL2.bbnet.ad>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PCI buffer allocation in Linux device
Thread-Index: AcdWa5EjgWb8c5KgRomSo77saCOuOw==
From: "Joji Joseph" <Joji.Joseph@conexant.com>
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 22 Feb 2007 10:24:03.0468 (UTC) FILETIME=[9336CCC0:01C7566B]
X-TM-AS-Product-Ver: SMEX-7.0.0.1499-3.6.1039-15012.003
X-TM-AS-Result: No--7.565300-0.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a PCI host Device runs in Linux platform and the PCI slave device
runs in VxWorks platform.

The PCI DMA transmission is successful from host to slave when I have
allocated source data buffer with "dma_alloc_coherent" function and I
can read the data at the PCI slave (in vxwork platform) when DMA
interrupts happens at there.

But, Though the PCI DMA receive interrupt at the host side(in Linux
platform), I couldn't receive the data which sends from the pci slave
(in vxworks platform).

For allocating the buffer at the host side, I have used
"dma_alloc_coherent" as shown below,

pBuff =dma_alloc_coherent( NULL , lenBuf, &dma_handle, GFP_ATOMIC);

and keeping the physical address 'dma_handle' in buffer descriptor which
is used for the DMA transmission.

When interrupt happens at the host side, I am using the 'pBuff' virtual
address which was saved locally for reading the buffer.

But, the data which I am getting is not correct.

Could anybody help me out how I should allocate memory in this scenario?

Is there any other function which I should use apart from
"dma_alloc_coherent" to get the proper behavior?

Thanks a lot in advance for you help.

Regards
Joji

Conexant E-mail Firewall (Conexant.Com) made the following annotations---------------------------------------------------------------------********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

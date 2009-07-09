Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbZGIJgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbZGIJgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZGIJf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:35:59 -0400
Received: from mail.prodrive.nl ([194.151.106.228]:28934 "EHLO
	mail.prodrive.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbZGIJf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:35:58 -0400
X-Greylist: delayed 1857 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 05:35:58 EDT
X-TM-IMSS-Message-ID: <d62c34830003f086@prodrive.nl>
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: PCIe dma-able memory location in physical memory for Intel Nehalem + Tylersburg architecture
Date: Thu, 9 Jul 2009 11:04:59 +0200
Message-ID: <4CD35CD1F8085945B597F80EEC894213030C20F6@exc01.bk.prodrive.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PCIe dma-able memory location in physical memory for Intel Nehalem + Tylersburg architecture
Thread-Index: AcoAdFbJUgfNJ7SmQauzjQMtkxN2qA==
From: "Rob van de Voort" <rob.van.der.voort@Prodrive.nl>
To: <linux-kernel@vger.kernel.org>
X-TM-AS-Product-Ver: IMSS-7.0.0.6219-5.6.0.1016-16752.006
X-TM-AS-User-Approved-Sender: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have the following question regarding the (re-)allocation of dma-able
memory for a PCIe device. I wish to know on which CPU / Memory
controller the dma-able memory will be allocated. In addition i would
like to know how i can control this allocation process, or how to
reroute it to another CPU / Memory controller.

The system i use contains two Nehalem processors connected via intel QPI
bus. Both processors have 3GB of DDR3 RAM in their memory banks. The
PCIe bus is controlled by a tylersburg io hub which is also connected to
the intel QPI bus

The system runs a 64bit linux kernel. Furthermore a PCIe device which
can only use 32 bit addressing is connected to the PCIe bus. I want to
allocate dma-able memory for this device using a driver, i know how to
do this. For maximal performance i would like to control the allocation
of dma-able memory, in particular the allocation to a certain CPU /
memory controller. The tylersburg IO hub has an influence on this
allocation but can i influence this.

So my questions are:
-1- How can i know were our dma-able memory is allocated in physical
memory?
-2- How can i control / redirect this allocation to a certain memory
controller / CPU?

Thanks for any reply,

Rob van de Voort

P.S  I'd be grateful if people could point me in the direction of
resources I could read. Thus far I have gone over the PCI / DMA
documentation in
the kernel, and a couple of articles on lwn. 
If this is the wrong mailing list for this type of question i hope you
can redirect me to the correct one.



Disclaimer: The information contained in this email, including any attachments is 
confidential and is for the sole use of the intended recipient(s). Any unauthorized 
review, use, disclosure or distribution is prohibited. If you are not the intended 
recipient, please notify the sender immediately by replying to this message and 
destroy all copies of this message and any attachments.

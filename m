Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbZJMLrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbZJMLrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759537AbZJMLrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:47:00 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:54267 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536AbZJMLq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cusPAasZ8pwPqiC0qI/i67EeCIAi5cTzWJPD9TRodwn7eGg3AvgI+FN5xktrm8CDgw
         vPC9Jz+jhnncAzz3cQT3bg3NyqpErivxgmZanlJM3lhlHFAaQDYNBVNR8PQB7gEJcg7P
         MDFBQsu/d32vM2wPaFclo718WY/1qVDIIwIuY=
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 07:46:21 -0400
Message-ID: <ba1f10320910130446g33264abfy845e28856e2e6f69@mail.gmail.com>
Subject: Intel on-board NIC negotiates at 10mbps instead of 1gbps (new Intel 
	P55KG motherboard), driver bug?
From: Justin Piszcz <jpiszcz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently purchased/installed an Intel DP55KG motherboard and when I
boot from the System Rescue CD (1.3.0) the on-board NIC only
negotiates at 10mbps, when I plug the same cable into two other Intel
x1 PCI-e nics, they negotiate at 1gbps without any issue.  My old
system also negotiated at 1gbps (a DG965WH) board.

I understand support for chip has recently been added to the e1000e
driver, has this been resolved in newer kernels?

I am asking as I am still running memtest etc before putting the box
in production, thanks.

>From the logs:

e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: pci_enable_pcie_error_
reporting failed 0xfffffffb
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) (mac address)
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: ffffff-0ff

e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
e1000e 0000:00:19.0: irq 36 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 10 Mbps Full Duplex, Flow Control: RX
0000:00:19.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present

Please cc as I am not on the lists, thanks.

(resent as plain-text)

Justin.

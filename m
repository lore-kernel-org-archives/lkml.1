Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZIRNlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZIRNlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZIRNln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:41:43 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57615 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZIRNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=P2gHHkhZev49ZjVu6WSeylRPvBKkBzcJh2l9aINp7DKclOBTRuGjMgqVdIY2gWpi/i
         ibSVgI/Kv+7xTRWASXul3UsNav5ENuGtQW0hsTgiTI5UftfnrNqw9QruA7uSSvoqVjoB
         EF/b8cWSsVd88niSpgo8VPtfsZF0VD3J6Glo8=
MIME-Version: 1.0
Date: Fri, 18 Sep 2009 15:41:45 +0200
Message-ID: <c5bd819b0909180641n7c353b80tc15b9c9fe02d5c95@mail.gmail.com>
Subject: sky2 rx length errors
From: Grozdan <neutrino8@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Marvell onboard NIC (88E8053) and I've been noticing for a
while now a bit weird behavior with the sky2 driver. This mostly
occurs with newer kernels (2.6.30, 2.6.31) and my older distro kernel
(2.6.27.21) does not seem to have the same problem. Basically, the
sky2 driver will randomly and unpredictably spew rx length error
messages and reboot itself. I also noticed in dmesg that this mostly
occurs after "martian destination" messages. After this message, sky2
starts spewing messages as shown below and then reboots itself. It is
not really a big problem for me, but since I'm virtually always logged
in in IRC, the client always loses connection, waits for a few minutes
to get a response from the server and then relogs me again. I do not
think it's a HW problem as the Marvell NIC otherwise works perfectly
and I've checked my cable modem too which operates without a problem.
Any ideas?

PS: please cc me as I'm not subscribed to the mailing list

sky2 driver version 1.23
sky2 0000:05:00.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
sky2 0000:05:00.0: setting latency timer to 64
sky2 0000:05:00.0: PCI: Disallowing DAC for device
sky2 0000:05:00.0: Yukon-2 EC chip revision 2
sky2 0000:05:00.0: irq 53 for MSI/MSI-X
sky2 0000:05:00.0: No interrupt generated using MSI, switching to INTx mode.
sky2 eth0: addr 00:11:d8:a1:5b:0e
sky2 eth0: enabling interface
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx
.....
.....
martian destination 0.0.0.0 from 172.23.204.1, dev eth0
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x5ea0100 length 598
sky2 eth0: rx length error: status 0x5ea0100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x5ea0100 length 598
sky2 eth0: rx length error: status 0x5ea0100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598
sky2 eth0: rx length error: status 0x4420100 length 598

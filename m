Return-Path: <linux-kernel-owner+w=401wt.eu-S964905AbXBLNXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbXBLNXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964908AbXBLNXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:23:43 -0500
Received: from smtpd2.aruba.it ([62.149.128.207]:37628 "HELO smtp3.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964905AbXBLNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:23:42 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 08:23:42 EST
Subject: Post-boot PCI device detection
From: Andrea Galbusera <andrea.galbusera@teamware.it>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:16:57 +0100
Message-Id: <1171286217.5438.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
X-Spam-Rating: smtp3.aruba.it 1.6.2 0/1000/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I work on a custom board and I have a PCI realated question. Please
redirect me to a more suitable list if you find the following off-topic.

On my board I have a powerpc and an fpga that I need to configure at
boot: once this is accomplished, the fpga implements a PCI device. At
moment I use a "two stages boot" in order to let the PCI subsystem
correctly detect the new device. More in detail:
1. the system boots up my kernel
2. I configure the fpga through SPI with a suitable init script
3. I reboot the ppc (this does not clear fpga config, of course!)
4. Now the kernel show the PCI device and I can load its driver

This works but has performance issues. Here comes the question... Is
there a more suitable way to let the kernel know about the PCI device
being present on the bus without rebooting the system.
No hardware support is available to any sort of hotplug signaling, since
the fpga will never be removed from the system after boot.

How can I signal PCI that something new is present?
I read Documentation/pci.txt but this does not clarify my dubt.

Thank you in advance for any kind help.


-- 
Andrea Galbusera


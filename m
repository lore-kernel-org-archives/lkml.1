Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXEWMPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXEWMPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbXEWMPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:15:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:62454 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760379AbXEWMPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=XImDc8DMrthTshVIM1DaZZmY0ZMdjuFSkjetonIEc2A1YZhXBLctONmcLeC8HEbjM+K5mwNrtsGvkMDn4TZkscQcaBksIDPlqWFCKzyxP3oe5flcpRbFcurYnyZY4JBWG3qyoiWU+Htifjmx4rLwxNYXc4J8vD01/vcdU24TyO4=
Message-ID: <46543045.3030904@gmail.com>
Date: Wed, 23 May 2007 16:15:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-pci@atrey.karlin.mff.cuni.cz
CC: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: PCIE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Do the PCI Express chipsets also use the same PCI API ? The device
specifications are thus for the device that i am looking at:

 PCI Express interface

    * Compliant to PCI Express Base Specification 1.0a
    * The PCI Express circuit supports isochronous data traffic intended
for uninterrupted transfer of streaming data like video streaming
          o x1 PCI Express endpoint (2.5 Gbit/s)
          o Data and clock recovery from serial stream
          o Low jitter and BER
    * Type 0 configuration space header
          o 64-bit addressing
          o Single BAR; programmable address range of 17 bits, 18 bits,
19 bits or 20 bits dependent on application requirements
    * PCI Express capabilities
          o 128 bytes write packet size and 64 bytes read packet size
          o MSI support
          o Software directed power management of four device power
states (D0 to D3)
          o Active state power management of link states
          o Vendor specific capability for VC1 support; after reset VC1
isochronous capability is disabled

I have been trying the said card with a normal PCI style driver, but
while booting the kernel (2.6.21.1) i do get a message like this (an
Intel DP965LT motherboard with BIOS version:
MQ96510J.86A.1612.2006.1227.1513)
Also accessing the interrupt registers causes a hard freeze, for which
only the RESET button seems to be of any help.

Uncompressing Linux .. Ok, booting the kernel.
BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw
vendor)
PCI: Failed to allocate mem resource #6:20000@30000000 for 0000:01:00.0

Any ideas as to what could be wrong ?

Thanks,
Manu

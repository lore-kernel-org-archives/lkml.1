Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXFUSPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXFUSPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbXFUSPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:15:10 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:59825 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbXFUSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:15:08 -0400
Message-ID: <467AC01E.4020503@mandic.com.br>
Date: Thu, 21 Jun 2007 15:14:54 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>,
       shemminger@osdl.org
Subject: sky2 crash on suspend to RAM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Suspend to ram work very fine in my Toshiba M45-S355, but when laptop 
return (from RAM), my network connection crash, and I need unload and 
load again my sky2 module (using kernel 2.6.21.1).

My NIC is:
Marvell Technology Group Ltd. 88E8036 PCI-E Fast Ethernet Controller 
(rev 10)

See below my logs when return from ram:

kernel: sky2 eth1: disabling interface
kernel: sky2 eth1: enabling interface
kernel: sky2 eth1: ram buffer 4K
kernel: ADDRCONF(NETDEV_UP): eth1: link is not ready
kernel: uhci_hcd 0000:00:1d.3: remove, state 4
kernel: usb usb4: USB disconnect, address 1
kernel: uhci_hcd 0000:00:1d.3: USB bus 4 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
kernel: uhci_hcd 0000:00:1d.2: remove, state 4
kernel: usb usb3: USB disconnect, address 1
kernel: uhci_hcd 0000:00:1d.2: USB bus 3 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
kernel: uhci_hcd 0000:00:1d.1: remove, state 4
kernel: usb usb2: USB disconnect, address 1
kernel: uhci_hcd 0000:00:1d.1: USB bus 2 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
kernel: uhci_hcd 0000:00:1d.0: remove, state 1
kernel: usb usb1: USB disconnect, address 1
kernel: usb 1-1: USB disconnect, address 4
kernel: uhci_hcd 0000:00:1d.0: USB bus 1 deregistered
kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled
kernel: Stopping tasks ... done.
kernel: Suspending console(s)
kernel: sky2 eth1: Link is up at 100 Mbps, full duplex, flow control both
kernel: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
kernel: ACPI: PCI interrupt for device 0000:05:06.4 disabled
kernel: ACPI: PCI interrupt for device 0000:05:06.3 disabled
kernel: eth2: Going into suspend...
kernel: ACPI: PCI interrupt for device 0000:05:04.0 disabled
kernel: sky2 eth1: disabling interface
kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
kernel: ACPI: PCI interrupt for device 0000:00:1e.3 disabled
kernel: ACPI: PCI interrupt for device 0000:00:1e.2 disabled
kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
kernel: Intel machine check architecture supported.
kernel: Intel machine check reporting enabled on CPU#0.
kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11 
(level, low) -> IRQ 11
kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> Link [LNKB] -> GSI 10 
(level, low) -> IRQ 10
kernel: ACPI: PCI Interrupt 0000:00:1c.1[B] -> Link [LNKA] -> GSI 11 
(level, low) -> IRQ 11
kernel: PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> Link [LNKH] -> GSI 10 
(level, low) -> IRQ 10
kernel: ACPI: PCI Interrupt 0000:00:1e.2[A] -> Link [LNKB] -> GSI 10 
(level, low) -> IRQ 10
kernel: ACPI: PCI Interrupt 0000:00:1e.3[B] -> Link [LNKE] -> GSI 5 
(level, low) -> IRQ 5
kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> Link [LNKD] -> GSI 11 
(level, low) -> IRQ 11
kernel: sky2 eth1: enabling interface
kernel: sky2 eth1: ram buffer 4K
kernel: eth2: Coming out of suspend...
kernel: PCI: Enabling device 0000:05:04.0 (0000 -> 0002)
kernel: ACPI: PCI Interrupt 0000:05:04.0[A] -> Link [LNKA] -> GSI 11 
(level, low) -> IRQ 11
kernel: ACPI: PCI Interrupt 0000:05:06.2[C] -> Link [LNKG] -> GSI 6 
(level, low) -> IRQ 6
kernel: ACPI: PCI Interrupt 0000:05:06.3[D] -> Link [LNKE] -> GSI 5 
(level, low) -> IRQ 5
kernel: ACPI: PCI Interrupt 0000:05:06.4[A] -> Link [LNKC] -> GSI 11 
(level, low) -> IRQ 11
kernel: ata1.00: configured for UDMA/100
kernel: SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
kernel: sda: Write Protect is off
kernel: SCSI device sda: write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
kernel: sky2 eth1: Link is up at 100 Mbps, full duplex, flow control both
kernel: ata2.00: configured for UDMA/33
kernel: Restarting tasks ... done.
kernel: ipw2200: Radio Frequency Kill Switch is On:
kernel: Kill switch must be turned off for wireless networking to work.
kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11] 
MMIO=[b8000000-b80007ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
kernel: eth1394: eth0: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
kernel: USB Universal Host Controller Interface driver v3.0
kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKH] -> GSI 10 
(level, low) -> IRQ 10
kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
kernel: uhci_hcd 0000:00:1d.0: irq 10, io base 0x00001200
kernel: usb usb1: configuration #1 chosen from 1 choice
kernel: hub 1-0:1.0: USB hub found
kernel: hub 1-0:1.0: 2 ports detected
kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 
(level, low) -> IRQ 11
kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
kernel: uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001220
kernel: usb usb2: configuration #1 chosen from 1 choice
kernel: hub 2-0:1.0: USB hub found
kernel: hub 2-0:1.0: 2 ports detected
kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 
(level, low) -> IRQ 11
kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
kernel: uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001240
kernel: usb usb3: configuration #1 chosen from 1 choice
kernel: hub 3-0:1.0: USB hub found
kernel: hub 3-0:1.0: 2 ports detected
kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> Link [LNKA] -> GSI 11 
(level, low) -> IRQ 11
kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
kernel: uhci_hcd 0000:00:1d.3: irq 11, io base 0x00001260
kernel: usb usb4: configuration #1 chosen from 1 choice
kernel: hub 4-0:1.0: USB hub found
kernel: hub 4-0:1.0: 2 ports detected
kernel: usb 1-1: new low speed USB device using uhci_hcd and address 2
kernel: sky2 eth1: disabling interface
kernel: sky2 eth1: enabling interface
kernel: sky2 eth1: ram buffer 4K
kernel: ADDRCONF(NETDEV_UP): eth1: link is not ready
kernel: usb 1-1: configuration #1 chosen from 1 choice
kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye? as 
/class/input/input8
kernel: input: USB HID v1.00 Mouse [Microsoft Microsoft 3-Button Mouse 
with IntelliEye?] on usb-0000:00:1d.0-1
kernel: ADDRCONF(NETDEV_UP): eth2: link is not ready
kernel: sky2 eth1: Link is up at 100 Mbps, full duplex, flow control both
kernel: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
dhcdbd: message_handler: message handler not found under 
/com/redhat/dhcp/eth1 for sub-path eth1.dbus.get.host_name
dhcdbd: message_handler: message handler not found under 
/com/redhat/dhcp/eth1 for sub-path eth1.dbus.get.domain_name
dhcdbd: message_handler: message handler not found under 
/com/redhat/dhcp/eth1 for sub-path eth1.dbus.get.nis_domain
dhcdbd: message_handler: message handler not found under 
/com/redhat/dhcp/eth1 for sub-path eth1.dbus.get.nis_servers
gconfd (yamane-5230): iniciando (versão 2.16.1), pid 5230 usuário 'yamane'
gconfd (yamane-5230): Address 
"xml:readonly:/etc/gconf/gconf.xml.mandatory" resolved from a config 
source with only read permissions in position 0
gconfd (yamane-5230): O endereço "xml:readwrite:/home/yamane/.gconf" 
resolved from a config source with write permissions in positiono 1
gconfd (yamane-5230): Address 
"xml:readonly:/etc/gconf/gconf.xml.defaults" resolved from a config 
source with only read permissions in position 2
gconfd (yamane-5230): Address 
"xml:readonly:/var/lib/gconf/debian.defaults" resolved from a config 
source with only read permissions in position 3
gconfd (yamane-5230): Address "xml:readonly:/var/lib/gconf/defaults" 
resolved from a config source with only read permissions in position 4

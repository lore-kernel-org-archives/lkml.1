Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZI2TEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZI2TEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZI2TEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:04:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:55938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZI2TEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:04:23 -0400
Date: Tue, 29 Sep 2009 21:11:25 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc2: wlan rt73 dead
Message-ID: <20090929191125.GA5640@fancy-poultry.org>
References: <20090929170615.GA5539@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929170615.GA5539@fancy-poultry.org>
Organization: private site
X-OpenPGP-KeyID: 0x3FAF957D
X-OpenPGP-Fingerprint: 0BAE BB83 8B8A 3DE4 08F3  CEB9 DA0F CCBB 3FAF 957D
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20090822 (GNU/Linux 2.6.31.1 x86_64)
X-Provags-ID: V01U2FsdGVkX1+kiO3NkeM3Ajn4AOwd9CSImSWQHIcigr9cZ4W
 MAp9+6phmpYAD2LSKKqBbcaC4FmOo6RoYqYf0h9y2+wBnIRasw
 5qn4Xt1btgsiN5IJ7JLrg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.2009, Heinz Diehl wrote: 

[....]

I investigated a little bit further, and that's what the logs say after
activating the adapter by pushing/pulling:

[....]
Sep 29 20:57:24 liesel kernel: usb 1-7: new high speed USB device using ehci_hcd and address 6
Sep 29 20:57:25 liesel kernel: usb 1-7: New USB device found, idVendor=07d1, idProduct=3c03
Sep 29 20:57:25 liesel kernel: usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Sep 29 20:57:25 liesel kernel: usb 1-7: Product: 802.11 bg WLAN
Sep 29 20:57:25 liesel kernel: usb 1-7: Manufacturer: Ralink
Sep 29 20:57:25 liesel kernel: usb 1-7: configuration #1 chosen from 1 choice
Sep 29 20:57:25 liesel kernel: phy2 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
Sep 29 20:57:25 liesel kernel: phy2 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
Sep 29 20:57:25 liesel kernel: phy2 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
Sep 29 20:57:25 liesel kernel: phy2: Selected rate control algorithm 'minstrel'
Sep 29 20:57:25 liesel kernel: Registered led device: rt73usb-phy2::radio
Sep 29 20:57:25 liesel kernel: Registered led device: rt73usb-phy2::assoc
Sep 29 20:57:25 liesel kernel: Registered led device: rt73usb-phy2::quality
Sep 29 20:57:25 liesel kernel: usbcore: registered new interface driver rt73usb
Sep 29 20:57:25 liesel ifup:     wlan0     
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt73.bin'.
Sep 29 20:57:25 liesel kernel: rt73usb 1-7:1.0: firmware: requesting rt73.bin
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Sep 29 20:57:25 liesel kernel: phy2 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
Sep 29 20:57:25 liesel ifup-dhcp: Starting DHCP4 client on wlan0
Sep 29 20:57:25 liesel dhcpcd[8016]: wlan0: dhcpcd 3.2.3 starting
Sep 29 20:57:25 liesel dhcpcd[8016]: wlan0: hardware address = 00:1c:f0:99:ee:e2
Sep 29 20:57:25 liesel dhcpcd[8016]: wlan0: broadcasting for a lease
Sep 29 20:57:26 liesel ifup-dhcp: . 
Sep 29 20:57:28 liesel ifup-dhcp: . 
Sep 29 20:57:30 liesel ifup-dhcp: . 
Sep 29 20:57:32 liesel ifup-dhcp: . 
Sep 29 20:57:34 liesel ifup-dhcp: . 
Sep 29 20:57:37 liesel ifup-dhcp: . 
Sep 29 20:57:39 liesel ifup-dhcp: . 
Sep 29 20:57:41 liesel ifup-dhcp: . 
Sep 29 20:57:43 liesel ifup-dhcp:  
Sep 29 20:57:43 liesel ifup-dhcp:     wlan0     DHCP4 continues in background
Sep 29 20:57:45 liesel dhcpcd[8016]: wlan0: timed out
Sep 29 20:57:45 liesel dhcpcd[8016]: wlan0: trying to use old lease in /var/lib/dhcpcd/dhcpcd-wlan0.info'
Sep 29 20:57:45 liesel dhcpcd[8016]: wlan0: adding IP address 192.169.1.102/24
Sep 29 20:57:45 liesel dhcpcd[8016]: wlan0: adding default route via 192.169.1.1 metric 0
Sep 29 20:57:45 liesel avahi-daemon[5342]: Joining mDNS multicast group on interface wlan0.IPv4 with address 192.169.1.102.
Sep 29 20:57:45 liesel avahi-daemon[5342]: New relevant interface wlan0.IPv4 for mDNS.
Sep 29 20:57:45 liesel avahi-daemon[5342]: Registering new address record for 192.169.1.102 on wlan0.IPv4.
Sep 29 20:57:46 liesel syslog-ng[3374]: Configuration reload request received, reloading configuration;
Sep 29 20:57:46 liesel syslog-ng[3374]: New configuration initialized;
[....]

And that's it. Tha adapter is "off", and no connection is possible. It's
strongly 2.6.32-rc2 related, no problems with any other kernel before.




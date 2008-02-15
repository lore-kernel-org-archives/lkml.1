Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYBOSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYBOSP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYBOSPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:15:16 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56687 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYBOSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:15:15 -0500
To: auke-jan.h.kok@intel.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <E1JQ4ik-0005iq-NH@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Fri, 15 Feb 2008 18:51:34 +0100)
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <47B5BDC0.3020003@intel.com> <E1JQ3cu-0005ZW-7k@pomaz-ex.szeredi.hu> <47B5C38A.5000909@intel.com> <E1JQ4ik-0005iq-NH@pomaz-ex.szeredi.hu>
Message-Id: <E1JQ55V-0005nd-R5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 19:15:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here's the NetworkManager side of the log:

==========================================================================
Feb 15 12:27:30 tucsk NetworkManager: <info>  starting...
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429242] nm_system_device_get_system_config(): found config '/etc/sysconfig/network/ifcfg-eth0' for interface 'eth0'
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429334] nm_system_device_get_system_config(): BOOTPROTO=dhcp
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429373] nm_system_device_get_system_config(): ------ Config (eth0)
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429392] nm_system_device_get_system_config(): dhcp=1
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429423] nm_system_device_get_system_config(): addr=0.0.0.0
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429441] nm_system_device_get_system_config(): gw=0.0.0.0
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429458] nm_system_device_get_system_config(): mask=0.0.0.0
Feb 15 12:27:30 tucsk NetworkManager: <debug> [1203074850.429476] nm_system_device_get_system_config(): --------------------- 
Feb 15 12:27:30 tucsk NetworkManager: <info>  eth0: Device is fully-supported using driver 'e1000e'.
Feb 15 12:27:30 tucsk NetworkManager: <info>  nm_device_init(): waiting for device's worker thread to start
Feb 15 12:27:30 tucsk NetworkManager: <info>  nm_device_init(): device's worker thread started, continuing.
Feb 15 12:27:30 tucsk NetworkManager: <info>  Now managing wired Ethernet (802.3) device 'eth0'.
Feb 15 12:27:30 tucsk NetworkManager: <info>  Deactivating device eth0.
Feb 15 12:27:32 tucsk NetworkManager: <info>  Will activate wired connection 'eth0' because it now has a link.
Feb 15 12:27:32 tucsk NetworkManager: <info>  SWITCH: no current connection, found better connection 'eth0'.
Feb 15 12:27:33 tucsk NetworkManager: <info>  Will activate connection 'eth0'.
Feb 15 12:27:33 tucsk NetworkManager: <info>  Device eth0 activation scheduled...
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) started...
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 1 of 5 (Device Prepare) scheduled...
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 1 of 5 (Device Prepare) started...
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) scheduled...
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 1 of 5 (Device Prepare) complete.
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) starting...
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) successful.
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 3 of 5 (IP Configure Start) scheduled.
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) complete.
Feb 15 12:27:33 tucsk NetworkManager: <info>  Activation (eth0) Stage 3 of 5 (IP Configure Start) started...
Feb 15 12:27:35 tucsk NetworkManager: <info>  Activation (eth0) Beginning DHCP transaction.
Feb 15 12:27:35 tucsk NetworkManager: <info>  Activation (eth0) Stage 3 of 5 (IP Configure Start) complete.
Feb 15 12:27:35 tucsk NetworkManager: <info>  DHCP daemon state is now 12 (successfully started) for interface eth0
Feb 15 12:28:07 tucsk NetworkManager: <info>  Updating allowed wireless network lists.
Feb 15 12:28:10 tucsk NetworkManager: <info>  Old device 'eth0' activating, won't change.
Feb 15 12:28:20 tucsk NetworkManager: <info>  Device 'eth0' DHCP transaction took too long (>45s), stopping it.
Feb 15 12:28:21 tucsk NetworkManager: <info>  Activation (eth0) Stage 4 of 5 (IP Configure Timeout) scheduled...
Feb 15 12:28:21 tucsk NetworkManager: <info>  Activation (eth0) Stage 4 of 5 (IP Configure Timeout) started...
Feb 15 12:28:21 tucsk NetworkManager: <info>  No DHCP reply received.  Automatically obtaining IP via Zeroconf.
==========================================================================

So it does indeed look like some communication problem between
NetworkManager and dhclient, as NetworkManager thinks there was no
DHCP reply when in fac there was one:

==========================================================================
Feb 15 12:27:32 tucsk kernel: [   35.169183] 0000:02:00.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
Feb 15 12:27:32 tucsk kernel: [   35.169190] 0000:02:00.0: eth0: 10/100 speed: disabling TSO
Feb 15 12:27:40 tucsk dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 4
Feb 15 12:27:40 tucsk dhclient: DHCPOFFER from 192.168.0.1
Feb 15 12:27:45 tucsk dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
Feb 15 12:27:45 tucsk dhclient: DHCPACK from 192.168.0.1
Feb 15 12:27:46 tucsk dhclient: bound to 192.168.0.9 -- renewal in 1539 seconds.
Feb 15 12:28:20 tucsk dhclient: caught deadly SIGTERM
Feb 15 12:28:20 tucsk dhclient: could not restore resolv.conf: No such file or directory
Feb 15 12:28:20 tucsk dhclient: DHCPRELEASE on eth0 to 192.168.0.1 port 67
Feb 15 12:28:20 tucsk dhclient: send_packet: Network is unreachable
Feb 15 12:28:20 tucsk dhclient: send_packet: please consult README file regarding broadcast address.
==========================================================================

So AFAICT, this probably has nothing to do with e1000e :)

Thanks,
Miklos

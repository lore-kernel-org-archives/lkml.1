Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbYHFFAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbYHFFAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYHFFAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:00:08 -0400
Received: from mail142.messagelabs.com ([216.82.249.99]:59293 "HELO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753108AbYHFFAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:00:06 -0400
X-VirusChecked: Checked
X-Env-Sender: Pramod.Kumble@lntinfotech.com
X-Msg-Ref: server-9.tower-142.messagelabs.com!1217998730!30831898!16
X-StarScan-Version: 5.5.12.14.2; banners=lntinfotech.com,-,-
X-Originating-IP: [125.17.191.34]
To: linux-kernel@vger.kernel.org
Subject: g_ether issues with linux host
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OF4699D03E.F85F3AC7-ON6525749D.001B5CE4-6525749D.001B853B@lntinfotech.com>
From: Pramod Kumble <Pramod.Kumble@lntinfotech.com>
Date: Wed, 6 Aug 2008 10:30:37 +0530
X-MIMETrack: Serialize by Router on BANGALORE/LNTINFOTECH(Release 7.0.3|September 26, 2007) at
 08/06/2008 10:30:52 AM,
	Serialize complete at 08/06/2008 10:30:52 AM,
	Itemize by SMTP Server on MAILRELAY2/LNTINFOTECH(Release 7.0.2FP2|May 14, 2007) at
 08/06/2008 10:30:05 AM,
	Serialize by Router on MAILRELAY2/LNTINFOTECH(Release 7.0.2FP2|May 14, 2007) at
 08/06/2008 10:30:09 AM,
	Serialize complete at 08/06/2008 10:30:09 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
 
I am trying to set up USB networking between the linux host and 
developement board.I am using g_ether gadget along with the controller 
driver.Currently the code is tested with the windows host (xp service pack 
2). RNDIS option in g_ether is enabled and it works fine with windows 
host.ftp,telnet and ping are working. With the linux host i am disabling 
RNDIS and using the CDC option. Currently i am facing following problems.
 
1)With RedHat host (2.4.20) on connecting the cable i get the new network 
interface "eth1". The dmesg output is given below.
 
hub.c: new USB device 00:1f.2-1, assigned address 4
usb_control/bulk_msg: timeout
usb_control/bulk_msg: timeout
usb-uhci.c: interrupt, status 2, frame# 97
usb.c: USB device not responding, giving up (error=-84)
hub.c: new USB device 00:1f.2-1, assigned address 5
CDCEther.c: Found Header descriptor, CDC version 110.
CDCEther.c: Imperfect filtering support - need sw hashing
CDCEther.c: Can't use SetEthernetMulticastFilters request
CDCEther.c: detected BULK OUT packets of size 64
CDCEther.c: interrupt address: 3
CDCEther.c: interrupt interval: 32
divert: allocating divert_blk for eth1
CDCEther.c: eth1: Linux 2.6.10_mobilinux410-cl-jade-1.3.32/cl_udc Ethernet 
Gadget
CDCEther.c: eth1: 9E:3F:31:0E:40:24
 
But if i try to activate the network interface through "ifconfig eth1 up" 
i get following error.
 
CDCEther.c: usb_set_interface() failed
CDCEther.c: Attempted to set interfac 1
CDCEther.c: To alternate setting 1
CDCEther.c: CDCEther_open can't enable_net_traffic() - -1
 
2) With fedora linux host (2.6.21 kernel) i am getting following messages 
in dmesg output.
 
usb 1-2: new high speed USB device using ehci_hcd and address 4
usb 1-2: configuration #1 chosen from 1 choice
cdc_ether: probe of 1-2:1.0 failed with error -32
usbcore: registered new interface driver cdc_ether
 
The required modules usbnet and cdc_ether are loaded on host side, but on 
output of "ifconfig -a" i am not getting "usb0" interface.

Am i missing any configuratoin on host side.??  any help is greatly 
appreciated.

Thanks and Regards
Pramod


______________________________________________________________________

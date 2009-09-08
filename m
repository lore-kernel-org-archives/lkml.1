Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZIHNMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZIHNMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZIHNMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:12:55 -0400
Received: from mail06.o2online.de ([82.113.101.34]:37373 "EHLO
	mail06.o2online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZIHNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:12:54 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 09:12:54 EDT
From: "Hans-J. Ullrich" <hans.ullrich@loop.de>
To: linux-kernel@vger.kernel.org
Subject: Cannot register at bugzilla (bugreport added)
Date: Tue, 8 Sep 2009 15:07:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-amd64; KDE/4.3.1; x86_64; ; )
X-Face: LB;lTy:GLW8hra5s`^tCMJLt\y\ZLOevi~OFid.NO'V-#Ut?3hNz.B1\B\aoc^E@
 =?utf-8?q?xgqWwg=0A=096NQD=23EjyJlUAJh=26=7Ex8bUDEG52=5Cz5dPOAC?=)t;;G/"
 =?utf-8?q?OoHfo=2EQl=5Be=3BD=23F!=26=7D=25*=24=5CVT=5CeofWtk=0A=091=5CRQE9?=
 =?utf-8?q?pp=5FatooYt=23*n*9vQQ=27LNS3=3As=5BdIZ=26b?=(zV8Z44u1gL`.|K21Q)"*m@
 =?utf-8?q?f=26=27PF=7DiyFWi=0A=09=5D?=>Sz*@YZ\gdg|"dAlaa<yhS9b8
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909081507.25793.hans.ullrich@loop.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi dear webmasters,

sorry to write to you, but I was not able to register at bugzilla.kernel.org.

I tried two e-mail adresses: hans.ullrich@loop.de and kontakt@ullrich-it.de.

Ther reasonn why I wanted to register is a bugreport for the kernel module 
"ath5k". It would be nice, if you can register me, and maybe send this 
bugreport to the nice maintainer of ath5k.

The bugreport is as follows:

---------------------------------- snip --------------------------------------

kernel-module "ath5k" gets no IP when using dhcp


Description: It is not possible, to get an IP-address by using dhcp with the 
kernel-module ath5k. It is possible, to give a fixed IP to that module.

It seems, the kernel-module is not recognizing dhcp-offers (I remember, this 
problem appeared in some versions of madwifi-driver, too), although sometimes 
it seems to work, mostly, when the device already got an IP.

If you ask me, I would define this behaviour as "very, very unstable".

This is the output in console:

# iwconfig wlan0 key off essid UIT-mobile mode managed
# dhclient -s 192.168.1.5 wlan0

Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

Listening on LPF/wlan0/00:1d:d9:4c:88:10
Sending on   LPF/wlan0/00:1d:d9:4c:88:10
Sending on   Socket/fallback
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 4
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 10
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 14
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 12
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 10
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 10
DHCPDISCOVER on wlan0 to 192.168.1.5 port 67 interval 1
No DHCPOFFERS received.
No working leases in persistent database - sleeping.

#

------------------------ snap -------------------------------

I hope this helps a little bit. I will be pleased, if I can help you more, so 
feel free to ask for more information. 

There are already other reports of this problem in discussion forums. It 
seems, the old madwifi-driver works better with dhcp - so people say.


Thank you for your help! And thank you for your patience because of this 
unusual bugreporting, I apologize for that!


Best regards

Hans-J. Ullrich

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbXEORuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbXEORuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXEORuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:50:46 -0400
Received: from mail4.webhostingstar.com ([67.106.77.50]:35946 "HELO
	mail4.webhostingstar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755314AbXEORup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:50:45 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 13:50:45 EDT
Message-ID: <20070515124256.ijmnpcako4g8w8g0@67.106.77.50>
Date: Tue, 15 May 2007 12:42:56 -0500
From: art@usfltd.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org
Subject: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.22-rc1-gfaa8b6c3 #130 SMP PREEMPT Tue May 15 08:45:16 CDT  
2007 x86_64 x86_64 x86_64 GNU/Linux

udev.x86_64  095

usb hotplug/udev cannot correctly register usb/scanners, usb/cameras
udev doesn't create devices in /dev like /dev/scanner etc
but we can see devices in /proc/bus/usb/devices
...
T:  Bus=02 Lev=02 Prnt=03 Port=01 Cnt=02 Dev#= 10 Spd=12  MxCh= 0
D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=03f0 ProdID=0601 Rev= 1.00
S:  Manufacturer=Hewlett-Packard
S:  Product=HP ScanJet 6300C
S:  SerialNumber=xxxxxxxxxx
C:* #Ifs= 1 Cfg#= 1 Atr=60 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=00(>ifc ) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  16 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   1 Ivl=250ms
...

it works OK with kernel-2.6.20

can update udev to version 111 help solve this problem ???

xboom




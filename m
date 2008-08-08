Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYIKUvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYIKUvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYIKUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:50:55 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:1570 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYIKUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:50:55 -0400
Message-ID: <489BDE84.5020702@netone.net.tr>
Date: Fri, 08 Aug 2008 08:49:56 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] USB Mass Storage Problem via Linux-2.6.27-rc1/2
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2008 05:46:51.0704 (UTC) FILETIME=[2815C380:01C8F91A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I tried to connect my Sonyericsson K800i in "USB Mass Storage" 
mode, it didn't recognize it as a USB Mass Storage and also freezes the 
"lsusb". These strange behavior exist on both Linux-2.6.27-rc1 and rc2. 
At the logs:

Aug  7 12:05:17 tarkane kernel: usb 5-2: Product: Sony Ericsson K800
Aug  7 12:05:17 tarkane kernel: usb 5-2: Manufacturer: Sony Ericsson
Aug  7 12:05:17 tarkane kernel: usb 5-2: SerialNumber: 3534270171822450
Aug  7 12:05:20 tarkane kernel: cdc_acm 5-2:3.1: ttyACM0: USB ACM device
Aug  7 12:05:20 tarkane kernel: cdc_acm 5-2:3.3: ttyACM1: USB ACM device
Aug  7 12:05:20 tarkane kernel: usbcore: registered new interface driver 
cdc_acm
Aug  7 12:05:20 tarkane kernel: cdc_acm: v0.26:USB Abstract Control 
Model driver for USB modemsand ISDN adapters
Aug  7 12:05:20 tarkane kernel: usb0: register 'cdc_ether' at 
usb-0000:00:1d.3-2, CDC Ethernet Device, 02:80:37:06:03:00
Aug  7 12:05:20 tarkane kernel: usbcore: registered new interface driver 
cdc_ether
Aug  7 12:05:25 tarkane kernel: usb 5-2: USB disconnect, address 2


It seems; at least, it detects my K800i as a phone/modem device; but not 
as a USB Mass Storage. It's perfectly fine under  <=Linux-2.6.26.x 
kernels. Any help I can do to debug it more ?


Tarkan



Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZFMJTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZFMJTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 05:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZFMJTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 05:19:13 -0400
Received: from tur.go2.pl ([193.17.41.50]:44826 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbZFMJTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 05:19:12 -0400
Message-ID: <4A336ECB.1080909@o2.pl>
Date: Sat, 13 Jun 2009 11:18:03 +0200
From: Warpme <warpme@o2.pl>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.28 -> 2.6.30 migration issue
Content-Type: multipart/mixed;
 boundary="------------000709000409080406070908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709000409080406070908
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hi *

I just migrate from 2.6.28.10 to 2.6.30 and have following issue:

In 2.6.28.10 (and earlier kernels) listing of /sys/class/lirc/lirc0/device/
gives me following ouptput:

-----------------------------------------------------
access      user      group     date             size  name

drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  ..
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  3-1:1.0
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  driver
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  ep_00
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  lirc
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  power
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  subsystem
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  usb_device
drwxr-xr-x  root      root      Jun 13 08:14    <DIR>  usb_endpoint
-rw-r--r--  root      root      Jun 13 08:14  4096  B  authorized
-rw-r--r--  root      root      Jun 13 08:14  4096  B  bConfigurationValue
-r--r--r--  root      root      Jun 13 08:14  4096  B  bDeviceClass
-r--r--r--  root      root      Jun 13 08:14  4096  B  bDeviceProtocol
-r--r--r--  root      root      Jun 13 08:14  4096  B  bDeviceSubClass
-r--r--r--  root      root      Jun 13 08:14  4096  B  bMaxPacketSize0
-r--r--r--  root      root      Jun 13 08:14  4096  B  bMaxPower
-r--r--r--  root      root      Jun 13 08:14  4096  B  bNumConfigurations
-r--r--r--  root      root      Jun 13 08:14  4096  B  bNumInterfaces
-r--r--r--  root      root      Jun 13 08:14  4096  B  bcdDevice
-r--r--r--  root      root      Jun 13 08:14  4096  B  bmAttributes
-r--r--r--  root      root      Jun 13 08:14  4096  B  busnum
-r--r--r--  root      root      Jun 13 08:14  4096  B  configuration
-r--r--r--  root      root      Jun 13 08:14    64 kB  descriptors
-r--r--r--  root      root      Jun 13 08:14  4096  B  dev
-r--r--r--  root      root      Jun 13 08:14  4096  B  devnum
-r--r--r--  root      root      Jun 13 08:14  4096  B  idProduct
-r--r--r--  root      root      Jun 13 08:14  4096  B  idVendor
-r--r--r--  root      root      Jun 13 08:14  4096  B  manufacturer
-r--r--r--  root      root      Jun 13 08:14  4096  B  maxchild
-r--r--r--  root      root      Jun 13 08:14  4096  B  product
-r--r--r--  root      root      Jun 13 08:14  4096  B  quirks
-r--r--r--  root      root      Jun 13 08:14  4096  B  serial
-r--r--r--  root      root      Jun 13 08:14  4096  B  speed
-rw-r--r--  root      root      Jun 13 08:14  4096  B  uevent
-r--r--r--  root      root      Jun 13 08:14  4096  B  urbnum
-r--r--r--  root      root      Jun 13 08:14  4096  B  version
--------------------------------------------------------

In 2.6.30 listing of /sys/class/lirc/lirc0/device/ gives me:

--------------------------------------------------------
access      user      group     date             size  name

drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  ..
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  driver
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  ep_01
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  ep_81
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  input
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  lirc
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  power
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  subsystem
drwxr-xr-x  root      root      Jun 13 08:18    <DIR>  usb_endpoint
-r--r--r--  root      root      Jun 13 08:18  4096  B  bAlternateSetting
-r--r--r--  root      root      Jun 13 08:18  4096  B  bInterfaceClass
-r--r--r--  root      root      Jun 13 08:18  4096  B  bInterfaceNumber
-r--r--r--  root      root      Jun 13 08:18  4096  B  bInterfaceProtocol
-r--r--r--  root      root      Jun 13 08:18  4096  B  bInterfaceSubClass
-r--r--r--  root      root      Jun 13 08:18  4096  B  bNumEndpoints
-r--r--r--  root      root      Jun 13 08:18  4096  B  modalias
-r--r--r--  root      root      Jun 13 08:18  4096  B  supports_autosuspend
-rw-r--r--  root      root      Jun 13 08:18  4096  B  uevent
------------------------------------------------------------

As You see, in 2.6.30 there is no entry like busnum.

As my initscripts relay on this entry  - I have issue with my system 
initialization.

Is above difference and intentional incomparability between 2.6.28 and 
2.6.30 kernels or it is rather result of my environment (i.e. something 
in kernel config should be changed) .

Thx in advance
 


--------------000709000409080406070908
Content-Type: text/x-vcard; charset=utf-8;
 name="warpme.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="warpme.vcf"

begin:vcard
fn:Warpme
n:;Warpme
email;internet:warpme@o2.pl
version:2.1
end:vcard


--------------000709000409080406070908--

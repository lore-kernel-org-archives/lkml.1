Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYLFWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYLFWh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 17:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYLFWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 17:37:46 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:7789 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYLFWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 17:37:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bC0w9QIoBud0B72A4Mkw6G9Mi8cz7euVciqG5NH7SURotZ9jbxcqA+W7KdyoiHThdy
         KqgDs6/QjDO0SCLUS9tYCrkMnjcEO00aAZ/gu9UGqR6khMwR0/s31W6ZI6oyi66d6vV3
         SlwOp5y3bhUmoFNV2fvYLcPW+89oOlcrDpDKs=
Message-ID: <12bfabe40812061437r5b3158a9h7e805203699aed23@mail.gmail.com>
Date: Sat, 6 Dec 2008 23:37:37 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <493AF2EA.4030601@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AE770.5030507@shaw.ca>
	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
	 <493AF2EA.4030601@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 10:47 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>
> The first one is just indicating that if a DTLB error occurs the overflow
> bit may be set incorrectly. It's not a false error though. The AAJ52 erratum
> would only occur immediately after powerup or wake from sleep states.
>
I'm going to post the kernel log. The mce appears at [  301.732037] :

Dec  6 11:42:22 debian-hell kernel: imklog 3.18.5, log source =
/proc/kmsg started.
Dec  6 11:42:22 debian-hell kernel:   8.094597] kobject:
'usbdev7.1_ep81' (ffff88012761e880): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094609] kobject:
'usbdev7.1_ep81' (ffff88012761e880): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-0:1.0/usb_endpoint/usbdev7.1_ep81'
Dec  6 11:42:22 debian-hell kernel: [    8.094646] kobject: '7-1'
(ffff8801270e2ba0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094658] kobject: '7-1'
(ffff8801270e2ba0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1'
Dec  6 11:42:22 debian-hell kernel: [    8.094695] kobject: '7-1:1.0'
(ffff8801270b0eb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094707] kobject: '7-1:1.0'
(ffff8801270b0eb8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0'
Dec  6 11:42:22 debian-hell kernel: [    8.094746] kobject: 'host3'
(ffff8801279324b8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094758] kobject: 'host3'
(ffff8801279324b8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3'
Dec  6 11:42:22 debian-hell kernel: [    8.094800] kobject: 'host3'
(ffff880127932830): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094812] kobject: 'host3'
(ffff880127932830): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/scsi_host/host3'
Dec  6 11:42:22 debian-hell kernel: [    8.094850] kobject:
'usbdev7.2_ep02' (ffff8801270b1fb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094862] kobject:
'usbdev7.2_ep02' (ffff8801270b1fb8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/usb_endpoint/usbdev7.2_ep02'
Dec  6 11:42:22 debian-hell kernel: [    8.094900] kobject:
'usbdev7.2_ep81' (ffff8801270b1728): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094912] kobject:
'usbdev7.2_ep81' (ffff8801270b1728): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/usb_endpoint/usbdev7.2_ep81'
Dec  6 11:42:22 debian-hell kernel: [    8.094950] kobject:
'usbdev7.2_ep00' (ffff8801270b2400): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.094962] kobject:
'usbdev7.2_ep00' (ffff8801270b2400): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/usb_endpoint/usbdev7.2_ep00'
Dec  6 11:42:22 debian-hell kernel: [    8.094999] kobject:
'usbdev7.1_ep00' (ffff88012761f110): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095011] kobject:
'usbdev7.1_ep00' (ffff88012761f110): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/usb_endpoint/usbdev7.1_ep00'
Dec  6 11:42:22 debian-hell kernel: [    8.095047] kobject:
'usb_host7' (ffff880126e612d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095059] kobject:
'usb_host7' (ffff880126e612d0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb_host/usb_host7'
Dec  6 11:42:22 debian-hell kernel: [    8.095094] kobject: 'usbmon7'
(ffff880126e60e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095106] kobject: 'usbmon7'
(ffff880126e60e88): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usbmon/usbmon7'
Dec  6 11:42:22 debian-hell kernel: [    8.095142] kobject:
'0000:00:1b.0' (ffff88012f3c4cb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095154] kobject:
'0000:00:1b.0' (ffff88012f3c4cb8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0'
Dec  6 11:42:22 debian-hell kernel: [    8.095195] kobject:
'0000:00:1c.0' (ffff88012f3c5500): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095207] kobject:
'0000:00:1c.0' (ffff88012f3c5500): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.0'
Dec  6 11:42:22 debian-hell kernel: [    8.095245] kobject:
'0000:00:1c.0:pcie00' (ffff88012920d348): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095256] kobject:
'0000:00:1c.0:pcie00' (ffff88012920d348): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie00'
Dec  6 11:42:22 debian-hell kernel: [    8.095293] kobject:
'0000:00:1c.0:pcie02' (ffff88012920d790): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095305] kobject:
'0000:00:1c.0:pcie02' (ffff88012920d790): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie02'
Dec  6 11:42:22 debian-hell kernel: [    8.095341] kobject:
'0000:00:1c.0:pcie03' (ffff88012920dbd8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095352] kobject:
'0000:00:1c.0:pcie03' (ffff88012920dbd8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie03'
Dec  6 11:42:22 debian-hell kernel: [    8.095389] kobject: '0000:06'
(ffff88012f3d02d8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095401] kobject: '0000:06'
(ffff88012f3d02d8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.0/pci_bus/0000:06'
Dec  6 11:42:22 debian-hell kernel: [    8.095437] kobject:
'0000:00:1c.1' (ffff88012f3c5d48): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095448] kobject:
'0000:00:1c.1' (ffff88012f3c5d48): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1'
Dec  6 11:42:22 debian-hell kernel: [    8.095486] kobject:
'0000:00:1c.1:pcie00' (ffff88012920e020): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095498] kobject:
'0000:00:1c.1:pcie00' (ffff88012920e020): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:00:1c.1:pcie00'
Dec  6 11:42:22 debian-hell kernel: [    8.095534] kobject:
'0000:00:1c.1:pcie02' (ffff88012920e468): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095546] kobject:
'0000:00:1c.1:pcie02' (ffff88012920e468): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:00:1c.1:pcie02'
Dec  6 11:42:22 debian-hell kernel: [    8.095583] kobject:
'0000:00:1c.1:pcie03' (ffff88012920e8b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095594] kobject:
'0000:00:1c.1:pcie03' (ffff88012920e8b0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:00:1c.1:pcie03'
Dec  6 11:42:22 debian-hell kernel: [    8.095630] kobject:
'0000:07:00.0' (ffff88012f3d12c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095642] kobject:
'0000:07:00.0' (ffff88012f3d12c0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.0'
Dec  6 11:42:22 debian-hell kernel: [    8.095688] kobject: 'host6'
(ffff8801264dc548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095700] kobject: 'host6'
(ffff8801264dc548): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.0/host6'
Dec  6 11:42:22 debian-hell kernel: [    8.095736] kobject: 'host6'
(ffff8801264dc8c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095748] kobject: 'host6'
(ffff8801264dc8c0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.0/host6/scsi_host/host6'
Dec  6 11:42:22 debian-hell kernel: [    8.095783] kobject: 'host7'
(ffff8801264dd590): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095795] kobject: 'host7'
(ffff8801264dd590): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.0/host7'
Dec  6 11:42:22 debian-hell kernel: [    8.095830] kobject: 'host7'
(ffff8801264dd908): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095843] kobject: 'host7'
(ffff8801264dd908): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.0/host7/scsi_host/host7'
Dec  6 11:42:22 debian-hell kernel: [    8.095879] kobject:
'0000:07:00.1' (ffff88012f3d1b08): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095890] kobject:
'0000:07:00.1' (ffff88012f3d1b08): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1'
Dec  6 11:42:22 debian-hell kernel: [    8.095928] kobject: 'host8'
(ffff8801264de5d8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095940] kobject: 'host8'
(ffff8801264de5d8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8'
Dec  6 11:42:22 debian-hell kernel: [    8.095975] kobject: 'host8'
(ffff8801264de950): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.095987] kobject: 'host8'
(ffff8801264de950): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/scsi_host/host8'
Dec  6 11:42:22 debian-hell kernel: [    8.096029] kobject:
'target8:0:0' (ffff880127542b40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096041] kobject:
'target8:0:0' (ffff880127542b40): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.096079] kobject: '8:0:0:0'
(ffff880127158328): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096091] kobject: '8:0:0:0'
(ffff880127158328): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.096129] kobject: 'sr0'
(ffff8801270f4458): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096142] kobject: 'sr0'
(ffff8801270f4458): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0/block/sr0'
Dec  6 11:42:22 debian-hell kernel: [    8.096181] kobject: '8:0:0:0'
(ffff8801270b30c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096193] kobject: '8:0:0:0'
(ffff8801270b30c8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0/bsg/8:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.096235] kobject: '8:0:0:0'
(ffff8801271586a0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096247] kobject: '8:0:0:0'
(ffff8801271586a0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0/scsi_device/8:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.096287] kobject: 'sg1'
(ffff8801276712d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096299] kobject: 'sg1'
(ffff8801276712d0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0/scsi_generic/sg1'
Dec  6 11:42:22 debian-hell kernel: [    8.096335] kobject: 'host9'
(ffff8801279a65d8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096346] kobject: 'host9'
(ffff8801279a65d8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host9'
Dec  6 11:42:22 debian-hell kernel: [    8.096383] kobject: 'host9'
(ffff8801279a6950): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096395] kobject: 'host9'
(ffff8801279a6950): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host9/scsi_host/host9'
Dec  6 11:42:22 debian-hell kernel: [    8.096430] kobject: '0000:07'
(ffff88012f3d0b20): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096442] kobject: '0000:07'
(ffff88012f3d0b20): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/pci_bus/0000:07'
Dec  6 11:42:22 debian-hell kernel: [    8.096478] kobject:
'0000:00:1c.4' (ffff88012f3c6590): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096490] kobject:
'0000:00:1c.4' (ffff88012f3c6590): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4'
Dec  6 11:42:22 debian-hell kernel: [    8.096527] kobject:
'0000:00:1c.4:pcie00' (ffff88012920ecf8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096539] kobject:
'0000:00:1c.4:pcie00' (ffff88012920ecf8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4/0000:00:1c.4:pcie00'
Dec  6 11:42:22 debian-hell kernel: [    8.096575] kobject:
'0000:00:1c.4:pcie02' (ffff88012920f140): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096587] kobject:
'0000:00:1c.4:pcie02' (ffff88012920f140): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4/0000:00:1c.4:pcie02'
Dec  6 11:42:22 debian-hell kernel: [    8.096623] kobject:
'0000:00:1c.4:pcie03' (ffff88012920f588): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096635] kobject:
'0000:00:1c.4:pcie03' (ffff88012920f588): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4/0000:00:1c.4:pcie03'
Dec  6 11:42:22 debian-hell kernel: [    8.096671] kobject:
'0000:08:00.0' (ffff88012f3d2b98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096683] kobject:
'0000:08:00.0' (ffff88012f3d2b98): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4/0000:08:00.0'
Dec  6 11:42:22 debian-hell kernel: [    8.096721] kobject: 'eth0'
(ffff880126508728): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096733] kobject: 'eth0'
(ffff880126508728): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4/0000:08:00.0/net/eth0'
Dec  6 11:42:22 debian-hell kernel: [    8.096770] kobject: '0000:08'
(ffff88012f3d23f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096782] kobject: '0000:08'
(ffff88012f3d23f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.4/pci_bus/0000:08'
Dec  6 11:42:22 debian-hell kernel: [    8.096817] kobject:
'0000:00:1c.5' (ffff88012f3c6dd8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096828] kobject:
'0000:00:1c.5' (ffff88012f3c6dd8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5'
Dec  6 11:42:22 debian-hell kernel: [    8.096866] kobject:
'0000:00:1c.5:pcie00' (ffff88012920f9d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096877] kobject:
'0000:00:1c.5:pcie00' (ffff88012920f9d0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5/0000:00:1c.5:pcie00'
Dec  6 11:42:22 debian-hell kernel: [    8.096914] kobject:
'0000:00:1c.5:pcie02' (ffff8801279381f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096925] kobject:
'0000:00:1c.5:pcie02' (ffff8801279381f0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5/0000:00:1c.5:pcie02'
Dec  6 11:42:22 debian-hell kernel: [    8.096962] kobject:
'0000:00:1c.5:pcie03' (ffff880127938638): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.096973] kobject:
'0000:00:1c.5:pcie03' (ffff880127938638): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5/0000:00:1c.5:pcie03'
Dec  6 11:42:22 debian-hell kernel: [    8.097010] kobject:
'0000:09:00.0' (ffff88012f3d3c28): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097022] kobject:
'0000:09:00.0' (ffff88012f3d3c28): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5/0000:09:00.0'
Dec  6 11:42:22 debian-hell kernel: [    8.097059] kobject: 'eth1'
(ffff880126530728): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097071] kobject: 'eth1'
(ffff880126530728): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5/0000:09:00.0/net/eth1'
Dec  6 11:42:22 debian-hell kernel: [    8.097116] kobject: '0000:09'
(ffff88012f3d3488): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097128] kobject: '0000:09'
(ffff88012f3d3488): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.5/pci_bus/0000:09'
Dec  6 11:42:22 debian-hell kernel: [    8.097164] kobject:
'0000:00:1d.0' (ffff88012f3c7620): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097175] kobject:
'0000:00:1d.0' (ffff88012f3c7620): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0'
Dec  6 11:42:22 debian-hell kernel: [    8.097213] kobject: 'usb4'
(ffff8801270f12c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097225] kobject: 'usb4'
(ffff8801270f12c8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usb4'
Dec  6 11:42:22 debian-hell kernel: [    8.097281] kobject: '4-0:1.0'
(ffff8801277568a0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097293] kobject: '4-0:1.0'
(ffff8801277568a0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usb4/4-0:1.0'
Dec  6 11:42:22 debian-hell kernel: [    8.097333] kobject:
'usbdev4.1_ep81' (ffff880127756cc8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097345] kobject:
'usbdev4.1_ep81' (ffff880127756cc8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usb4/4-0:1.0/usb_endpoint/usbdev4.1_ep81'
Dec  6 11:42:22 debian-hell kernel: [    8.097384] kobject:
'usbdev4.1_ep00' (ffff880127755ba8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097396] kobject:
'usbdev4.1_ep00' (ffff880127755ba8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usb4/usb_endpoint/usbdev4.1_ep00'
Dec  6 11:42:22 debian-hell kernel: [    8.097431] kobject:
'usb_host4' (ffff880127754ec0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097443] kobject:
'usb_host4' (ffff880127754ec0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usb_host/usb_host4'
Dec  6 11:42:22 debian-hell kernel: [    8.097479] kobject: 'usbmon4'
(ffff880127755750): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097491] kobject: 'usbmon4'
(ffff880127755750): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usbmon/usbmon4'
Dec  6 11:42:22 debian-hell kernel: [    8.097527] kobject:
'0000:00:1d.1' (ffff88012f3c8230): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097538] kobject:
'0000:00:1d.1' (ffff88012f3c8230): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1'
Dec  6 11:42:22 debian-hell kernel: [    8.097576] kobject: 'usb5'
(ffff8801270e1b10): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097587] kobject: 'usb5'
(ffff8801270e1b10): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1/usb5'
Dec  6 11:42:22 debian-hell kernel: [    8.097625] kobject: '5-0:1.0'
(ffff8801274f30f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097637] kobject: '5-0:1.0'
(ffff8801274f30f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1/usb5/5-0:1.0'
Dec  6 11:42:22 debian-hell kernel: [    8.097676] kobject:
'usbdev5.1_ep81' (ffff8801274f4640): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097688] kobject:
'usbdev5.1_ep81' (ffff8801274f4640): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1/usb5/5-0:1.0/usb_endpoint/usbdev5.1_ep81'
Dec  6 11:42:22 debian-hell kernel: [    8.097725] kobject:
'usbdev5.1_ep00' (ffff8801274f41f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097738] kobject:
'usbdev5.1_ep00' (ffff8801274f41f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1/usb5/usb_endpoint/usbdev5.1_ep00'
Dec  6 11:42:22 debian-hell kernel: [    8.097773] kobject:
'usb_host5' (ffff8801274f1fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097785] kobject:
'usb_host5' (ffff8801274f1fa8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1/usb_host/usb_host5'
Dec  6 11:42:22 debian-hell kernel: [    8.097821] kobject: 'usbmon5'
(ffff8801274f3510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097833] kobject: 'usbmon5'
(ffff8801274f3510): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.1/usbmon/usbmon5'
Dec  6 11:42:22 debian-hell kernel: [    8.097869] kobject:
'0000:00:1d.2' (ffff88012f3c8a78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097880] kobject:
'0000:00:1d.2' (ffff88012f3c8a78): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2'
Dec  6 11:42:22 debian-hell kernel: [    8.097918] kobject: 'usb6'
(ffff8801270e2358): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097929] kobject: 'usb6'
(ffff8801270e2358): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2/usb6'
Dec  6 11:42:22 debian-hell kernel: [    8.097967] kobject: '6-0:1.0'
(ffff8801274f6010): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.097978] kobject: '6-0:1.0'
(ffff8801274f6010): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2/usb6/6-0:1.0'
Dec  6 11:42:22 debian-hell kernel: [    8.098018] kobject:
'usbdev6.1_ep81' (ffff8801274f6438): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098030] kobject:
'usbdev6.1_ep81' (ffff8801274f6438): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2/usb6/6-0:1.0/usb_endpoint/usbdev6.1_ep81'
Dec  6 11:42:22 debian-hell kernel: [    8.098067] kobject:
'usbdev6.1_ep00' (ffff8801274f6cc8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098079] kobject:
'usbdev6.1_ep00' (ffff8801274f6cc8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2/usb6/usb_endpoint/usbdev6.1_ep00'
Dec  6 11:42:22 debian-hell kernel: [    8.098114] kobject:
'usb_host6' (ffff8801274f4ec0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098126] kobject:
'usb_host6' (ffff8801274f4ec0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2/usb_host/usb_host6'
Dec  6 11:42:22 debian-hell kernel: [    8.098162] kobject: 'usbmon6'
(ffff8801274f5750): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098174] kobject: 'usbmon6'
(ffff8801274f5750): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.2/usbmon/usbmon6'
Dec  6 11:42:22 debian-hell kernel: [    8.098209] kobject:
'0000:00:1d.7' (ffff88012f3c92c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098221] kobject:
'0000:00:1d.7' (ffff88012f3c92c0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7'
Dec  6 11:42:22 debian-hell kernel: [    8.098259] kobject: 'usb8'
(ffff880127adccc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098270] kobject: 'usb8'
(ffff880127adccc0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7/usb8'
Dec  6 11:42:22 debian-hell kernel: [    8.098313] kobject: '8-0:1.0'
(ffff880126e60628): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098324] kobject: '8-0:1.0'
(ffff880126e60628): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7/usb8/8-0:1.0'
Dec  6 11:42:22 debian-hell kernel: [    8.098364] kobject:
'usbdev8.1_ep81' (ffff880126e62848): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098376] kobject:
'usbdev8.1_ep81' (ffff880126e62848): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7/usb8/8-0:1.0/usb_endpoint/usbdev8.1_ep81'
Dec  6 11:42:22 debian-hell kernel: [    8.098414] kobject:
'usbdev8.1_ep00' (ffff880126e63520): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098426] kobject:
'usbdev8.1_ep00' (ffff880126e63520): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7/usb8/usb_endpoint/usbdev8.1_ep00'
Dec  6 11:42:22 debian-hell kernel: [    8.098462] kobject:
'usb_host8' (ffff880126e61fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098474] kobject:
'usb_host8' (ffff880126e61fa8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7/usb_host/usb_host8'
Dec  6 11:42:22 debian-hell kernel: [    8.098515] kobject: 'usbmon8'
(ffff880126e601b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098527] kobject: 'usbmon8'
(ffff880126e601b0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.7/usbmon/usbmon8'
Dec  6 11:42:22 debian-hell kernel: [    8.098570] kobject:
'0000:00:1e.0' (ffff88012f3c9b08): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098582] kobject:
'0000:00:1e.0' (ffff88012f3c9b08): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0'
Dec  6 11:42:22 debian-hell kernel: [    8.098619] kobject:
'0000:0a:06.0' (ffff88012f3d4cb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098631] kobject:
'0000:0a:06.0' (ffff88012f3d4cb8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0'
Dec  6 11:42:22 debian-hell kernel: [    8.098669] kobject: 'fw0'
(ffff8801270cab40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098681] kobject: 'fw0'
(ffff8801270cab40): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw0'
Dec  6 11:42:22 debian-hell kernel: [    8.098717] kobject: 'fw1'
(ffff8801270cb388): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098729] kobject: 'fw1'
(ffff8801270cb388): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1'
Dec  6 11:42:22 debian-hell kernel: [    8.098765] kobject: 'fw1.0'
(ffff8801270b12d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098777] kobject: 'fw1.0'
(ffff8801270b12d0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0'
Dec  6 11:42:22 debian-hell kernel: [    8.098814] kobject: 'host10'
(ffff880127159470): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098826] kobject: 'host10'
(ffff880127159470): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10'
Dec  6 11:42:22 debian-hell kernel: [    8.098865] kobject: 'host10'
(ffff8801271597e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098877] kobject: 'host10'
(ffff8801271597e8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/scsi_host/host10'
Dec  6 11:42:22 debian-hell kernel: [    8.098915] kobject:
'target10:0:0' (ffff8801270cbbd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098927] kobject:
'target10:0:0' (ffff8801270cbbd0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.098964] kobject: '10:0:0:0'
(ffff880127935490): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.098976] kobject: '10:0:0:0'
(ffff880127935490): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.099014] kobject: 'sdb'
(ffff8801270cc458): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099027] kobject: 'sdb'
(ffff8801270cc458): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb'
Dec  6 11:42:22 debian-hell kernel: [    8.099066] kobject: 'sdb1'
(ffff8801270b3520): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099079] kobject: 'sdb1'
(ffff8801270b3520): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb1'
Dec  6 11:42:22 debian-hell kernel: [    8.099119] kobject: 'sdb2'
(ffff8801270b3968): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099131] kobject: 'sdb2'
(ffff8801270b3968): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb2'
Dec  6 11:42:22 debian-hell kernel: [    8.099171] kobject: 'sdb3'
(ffff8801270b3db0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099183] kobject: 'sdb3'
(ffff8801270b3db0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb3'
Dec  6 11:42:22 debian-hell kernel: [    8.099223] kobject: 'sdb4'
(ffff8801270b41f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099235] kobject: 'sdb4'
(ffff8801270b41f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb4'
Dec  6 11:42:22 debian-hell kernel: [    8.099274] kobject: 'sdb5'
(ffff8801270b4640): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099287] kobject: 'sdb5'
(ffff8801270b4640): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb5'
Dec  6 11:42:22 debian-hell kernel: [    8.099326] kobject: 'sdb6'
(ffff8801270b4a88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099338] kobject: 'sdb6'
(ffff8801270b4a88): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb6'
Dec  6 11:42:22 debian-hell kernel: [    8.099382] kobject: 'sdb7'
(ffff8801270b4ed0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099395] kobject: 'sdb7'
(ffff8801270b4ed0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb7'
Dec  6 11:42:22 debian-hell kernel: [    8.099434] kobject: 'sdb8'
(ffff8801270b5318): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099446] kobject: 'sdb8'
(ffff8801270b5318): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/block/sdb/sdb8'
Dec  6 11:42:22 debian-hell kernel: [    8.099486] kobject: '10:0:0:0'
(ffff8801270b5fe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099499] kobject: '10:0:0:0'
(ffff8801270b5fe0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/bsg/10:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.099539] kobject: '10:0:0:0'
(ffff880127935808): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099552] kobject: '10:0:0:0'
(ffff880127935808): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/scsi_device/10:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.099591] kobject: '10:0:0:0'
(ffff8801270b2848): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099603] kobject: '10:0:0:0'
(ffff8801270b2848): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/scsi_disk/10:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.099643] kobject: 'sg2'
(ffff8801270b5b98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099655] kobject: 'sg2'
(ffff8801270b5b98): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/0000:0a:06.0/fw1/fw1.0/host10/target10:0:0/10:0:0:0/scsi_generic/sg2'
Dec  6 11:42:22 debian-hell kernel: [    8.099691] kobject: '0000:0a'
(ffff88012f3d4518): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099703] kobject: '0000:0a'
(ffff88012f3d4518): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1e.0/pci_bus/0000:0a'
Dec  6 11:42:22 debian-hell kernel: [    8.099739] kobject:
'0000:00:1f.0' (ffff88012f3ca350): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099749] kobject:
'0000:00:1f.0' (ffff88012f3ca350): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.0'
Dec  6 11:42:22 debian-hell kernel: [    8.099791] kobject:
'0000:00:1f.2' (ffff88012f3cab98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099803] kobject:
'0000:00:1f.2' (ffff88012f3cab98): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2'
Dec  6 11:42:22 debian-hell kernel: [    8.099841] kobject: 'host1'
(ffff8801279a0428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099852] kobject: 'host1'
(ffff8801279a0428): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1'
Dec  6 11:42:22 debian-hell kernel: [    8.099889] kobject: 'host1'
(ffff8801279a07a0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099900] kobject: 'host1'
(ffff8801279a07a0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/scsi_host/host1'
Dec  6 11:42:22 debian-hell kernel: [    8.099936] kobject:
'target1:0:0' (ffff8801270c9268): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099948] kobject:
'target1:0:0' (ffff8801270c9268): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.099983] kobject: '1:0:0:0'
(ffff880127933400): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.099995] kobject: '1:0:0:0'
(ffff880127933400): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.100041] kobject: 'sda'
(ffff8801270433c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100053] kobject: 'sda'
(ffff8801270433c8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda'
Dec  6 11:42:22 debian-hell kernel: [    8.100091] kobject: 'sda1'
(ffff880127a19728): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100104] kobject: 'sda1'
(ffff880127a19728): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda/sda1'
Dec  6 11:42:22 debian-hell kernel: [    8.100142] kobject: 'sda2'
(ffff880127a1a848): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100154] kobject: 'sda2'
(ffff880127a1a848): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda/sda2'
Dec  6 11:42:22 debian-hell kernel: [    8.100192] kobject: 'sda3'
(ffff880127a1d760): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100204] kobject: 'sda3'
(ffff880127a1d760): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda/sda3'
Dec  6 11:42:22 debian-hell kernel: [    8.100242] kobject: 'sda4'
(ffff880127a1dba8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100254] kobject: 'sda4'
(ffff880127a1dba8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda/sda4'
Dec  6 11:42:22 debian-hell kernel: [    8.100293] kobject: 'sda5'
(ffff880127a19b70): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100305] kobject: 'sda5'
(ffff880127a19b70): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda/sda5'
Dec  6 11:42:22 debian-hell kernel: [    8.100343] kobject: 'sda6'
(ffff880127a1a400): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100355] kobject: 'sda6'
(ffff880127a1a400): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sda/sda6'
Dec  6 11:42:22 debian-hell kernel: [    8.100393] kobject: '1:0:0:0'
(ffff8801270b05f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100405] kobject: '1:0:0:0'
(ffff8801270b05f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/bsg/1:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.100448] kobject: '1:0:0:0'
(ffff880127933778): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100460] kobject: '1:0:0:0'
(ffff880127933778): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/scsi_device/1:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.100497] kobject: '1:0:0:0'
(ffff880127411728): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100509] kobject: '1:0:0:0'
(ffff880127411728): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/scsi_disk/1:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.100547] kobject: 'sg0'
(ffff880127670e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100559] kobject: 'sg0'
(ffff880127670e88): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/scsi_generic/sg0'
Dec  6 11:42:22 debian-hell kernel: [    8.100595] kobject: 'host2'
(ffff8801279a3500): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100606] kobject: 'host2'
(ffff8801279a3500): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host2'
Dec  6 11:42:22 debian-hell kernel: [    8.100642] kobject: 'host2'
(ffff8801279a3878): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100653] kobject: 'host2'
(ffff8801279a3878): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.2/host2/scsi_host/host2'
Dec  6 11:42:22 debian-hell kernel: [    8.100690] kobject:
'0000:00:1f.3' (ffff88012f3cb3e0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100701] kobject:
'0000:00:1f.3' (ffff88012f3cb3e0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.3'
Dec  6 11:42:22 debian-hell kernel: [    8.100737] kobject:
'0000:00:1f.5' (ffff88012f3cbc28): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100749] kobject:
'0000:00:1f.5' (ffff88012f3cbc28): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.5'
Dec  6 11:42:22 debian-hell kernel: [    8.100787] kobject: 'host4'
(ffff8801279a4548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100798] kobject: 'host4'
(ffff8801279a4548): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.5/host4'
Dec  6 11:42:22 debian-hell kernel: [    8.100833] kobject: 'host4'
(ffff8801279a48c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100844] kobject: 'host4'
(ffff8801279a48c0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.5/host4/scsi_host/host4'
Dec  6 11:42:22 debian-hell kernel: [    8.100880] kobject: 'host5'
(ffff8801279a5590): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100892] kobject: 'host5'
(ffff8801279a5590): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.5/host5'
Dec  6 11:42:22 debian-hell kernel: [    8.100928] kobject: 'host5'
(ffff8801279a5908): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100940] kobject: 'host5'
(ffff8801279a5908): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.5/host5/scsi_host/host5'
Dec  6 11:42:22 debian-hell kernel: [    8.100976] kobject: '0000:00'
(ffff88012f3923f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.100987] kobject: '0000:00'
(ffff88012f3923f8): fill_kobj_path: path =
'/devices/pci0000:00/pci_bus/0000:00'
Dec  6 11:42:22 debian-hell kernel: [    8.101027] kobject: 'i8042'
(ffff88012761b0d8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101039] kobject: 'i8042'
(ffff88012761b0d8): fill_kobj_path: path = '/devices/platform/i8042'
Dec  6 11:42:22 debian-hell kernel: [    8.101075] kobject: 'serio0'
(ffff880127605e20): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101087] kobject: 'serio0'
(ffff880127605e20): fill_kobj_path: path =
'/devices/platform/i8042/serio0'
Dec  6 11:42:22 debian-hell kernel: [    8.101125] kobject: 'input1'
(ffff880127978930): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101136] kobject: 'input1'
(ffff880127978930): fill_kobj_path: path =
'/devices/platform/i8042/serio0/input/input1'
Dec  6 11:42:22 debian-hell kernel: [    8.101182] kobject: 'pcspkr'
(ffff880127a18608): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101193] kobject: 'pcspkr'
(ffff880127a18608): fill_kobj_path: path = '/devices/platform/pcspkr'
Dec  6 11:42:22 debian-hell kernel: [    8.101229] kobject:
'serial8250' (ffff88012754ced0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101241] kobject:
'serial8250' (ffff88012754ced0): fill_kobj_path: path =
'/devices/platform/serial8250'
Dec  6 11:42:22 debian-hell kernel: [    8.101287] kobject: 'ttyS0'
(ffff88012754d308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101299] kobject: 'ttyS0'
(ffff88012754d308): fill_kobj_path: path =
'/devices/platform/serial8250/tty/ttyS0'
Dec  6 11:42:22 debian-hell kernel: [    8.101335] kobject: 'ttyS1'
(ffff88012754d750): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101346] kobject: 'ttyS1'
(ffff88012754d750): fill_kobj_path: path =
'/devices/platform/serial8250/tty/ttyS1'
Dec  6 11:42:22 debian-hell kernel: [    8.101382] kobject: 'ttyS2'
(ffff88012754db98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101394] kobject: 'ttyS2'
(ffff88012754db98): fill_kobj_path: path =
'/devices/platform/serial8250/tty/ttyS2'
Dec  6 11:42:22 debian-hell kernel: [    8.101430] kobject: 'ttyS3'
(ffff88012754dfe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101441] kobject: 'ttyS3'
(ffff88012754dfe0): fill_kobj_path: path =
'/devices/platform/serial8250/tty/ttyS3'
Dec  6 11:42:22 debian-hell kernel: [    8.101481] kobject: 'vesafb.0'
(ffff880127938e98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101493] kobject: 'vesafb.0'
(ffff880127938e98): fill_kobj_path: path =
'/devices/platform/vesafb.0'
Dec  6 11:42:22 debian-hell kernel: [    8.101536] kobject: '00:00'
(ffff88012f3d5480): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101548] kobject: '00:00'
(ffff88012f3d5480): fill_kobj_path: path = '/devices/pnp0/00:00'
Dec  6 11:42:22 debian-hell kernel: [    8.101581] kobject: '00:01'
(ffff88012f3d5cc8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101592] kobject: '00:01'
(ffff88012f3d5cc8): fill_kobj_path: path = '/devices/pnp0/00:01'
Dec  6 11:42:22 debian-hell kernel: [    8.101626] kobject: '00:02'
(ffff88012f3d6510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101637] kobject: '00:02'
(ffff88012f3d6510): fill_kobj_path: path = '/devices/pnp0/00:02'
Dec  6 11:42:22 debian-hell kernel: [    8.101670] kobject: '00:03'
(ffff88012f3d6d58): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101681] kobject: '00:03'
(ffff88012f3d6d58): fill_kobj_path: path = '/devices/pnp0/00:03'
Dec  6 11:42:22 debian-hell kernel: [    8.101715] kobject: 'rtc0'
(ffff8801276075a0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101726] kobject: 'rtc0'
(ffff8801276075a0): fill_kobj_path: path =
'/devices/pnp0/00:03/rtc/rtc0'
Dec  6 11:42:22 debian-hell kernel: [    8.101760] kobject: '00:04'
(ffff88012f3d75a0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101771] kobject: '00:04'
(ffff88012f3d75a0): fill_kobj_path: path = '/devices/pnp0/00:04'
Dec  6 11:42:22 debian-hell kernel: [    8.101805] kobject: '00:05'
(ffff88012eca01b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101816] kobject: '00:05'
(ffff88012eca01b0): fill_kobj_path: path = '/devices/pnp0/00:05'
Dec  6 11:42:22 debian-hell kernel: [    8.101850] kobject: '00:06'
(ffff88012eca09f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101861] kobject: '00:06'
(ffff88012eca09f8): fill_kobj_path: path = '/devices/pnp0/00:06'
Dec  6 11:42:22 debian-hell kernel: [    8.101894] kobject: '00:07'
(ffff88012eca1240): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101905] kobject: '00:07'
(ffff88012eca1240): fill_kobj_path: path = '/devices/pnp0/00:07'
Dec  6 11:42:22 debian-hell kernel: [    8.101939] kobject: '00:08'
(ffff88012eca1a88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101950] kobject: '00:08'
(ffff88012eca1a88): fill_kobj_path: path = '/devices/pnp0/00:08'
Dec  6 11:42:22 debian-hell kernel: [    8.101983] kobject: '00:09'
(ffff88012eca22d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.101994] kobject: '00:09'
(ffff88012eca22d0): fill_kobj_path: path = '/devices/pnp0/00:09'
Dec  6 11:42:22 debian-hell kernel: [    8.102027] kobject: '00:0a'
(ffff88012eca2b18): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102039] kobject: '00:0a'
(ffff88012eca2b18): fill_kobj_path: path = '/devices/pnp0/00:0a'
Dec  6 11:42:22 debian-hell kernel: [    8.102073] kobject: '11:0'
(ffff880127756428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102084] kobject: '11:0'
(ffff880127756428): fill_kobj_path: path = '/devices/virtual/bdi/11:0'
Dec  6 11:42:22 debian-hell kernel: [    8.102125] kobject: '1:0'
(ffff88012754e428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102136] kobject: '1:0'
(ffff88012754e428): fill_kobj_path: path = '/devices/virtual/bdi/1:0'
Dec  6 11:42:22 debian-hell kernel: [    8.102170] kobject: '1:1'
(ffff88012754e870): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102181] kobject: '1:1'
(ffff88012754e870): fill_kobj_path: path = '/devices/virtual/bdi/1:1'
Dec  6 11:42:22 debian-hell kernel: [    8.102219] kobject: '1:10'
(ffff8801276192d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102231] kobject: '1:10'
(ffff8801276192d0): fill_kobj_path: path = '/devices/virtual/bdi/1:10'
Dec  6 11:42:22 debian-hell kernel: [    8.102265] kobject: '1:11'
(ffff880127619718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102276] kobject: '1:11'
(ffff880127619718): fill_kobj_path: path = '/devices/virtual/bdi/1:11'
Dec  6 11:42:22 debian-hell kernel: [    8.102310] kobject: '1:12'
(ffff880127619b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102321] kobject: '1:12'
(ffff880127619b60): fill_kobj_path: path = '/devices/virtual/bdi/1:12'
Dec  6 11:42:22 debian-hell kernel: [    8.102354] kobject: '1:13'
(ffff880127619fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102365] kobject: '1:13'
(ffff880127619fa8): fill_kobj_path: path = '/devices/virtual/bdi/1:13'
Dec  6 11:42:22 debian-hell kernel: [    8.102399] kobject: '1:14'
(ffff88012761a3f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102410] kobject: '1:14'
(ffff88012761a3f0): fill_kobj_path: path = '/devices/virtual/bdi/1:14'
Dec  6 11:42:22 debian-hell kernel: [    8.102448] kobject: '1:15'
(ffff88012761a838): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102460] kobject: '1:15'
(ffff88012761a838): fill_kobj_path: path = '/devices/virtual/bdi/1:15'
Dec  6 11:42:22 debian-hell kernel: [    8.102494] kobject: '1:2'
(ffff88012754ecb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102505] kobject: '1:2'
(ffff88012754ecb8): fill_kobj_path: path = '/devices/virtual/bdi/1:2'
Dec  6 11:42:22 debian-hell kernel: [    8.102539] kobject: '1:3'
(ffff88012754f100): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102550] kobject: '1:3'
(ffff88012754f100): fill_kobj_path: path = '/devices/virtual/bdi/1:3'
Dec  6 11:42:22 debian-hell kernel: [    8.102584] kobject: '1:4'
(ffff88012754f548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102595] kobject: '1:4'
(ffff88012754f548): fill_kobj_path: path = '/devices/virtual/bdi/1:4'
Dec  6 11:42:22 debian-hell kernel: [    8.102629] kobject: '1:5'
(ffff88012754f990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102640] kobject: '1:5'
(ffff88012754f990): fill_kobj_path: path = '/devices/virtual/bdi/1:5'
Dec  6 11:42:22 debian-hell kernel: [    8.102673] kobject: '1:6'
(ffff8801276181b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102684] kobject: '1:6'
(ffff8801276181b0): fill_kobj_path: path = '/devices/virtual/bdi/1:6'
Dec  6 11:42:22 debian-hell kernel: [    8.102717] kobject: '1:7'
(ffff8801276185f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102728] kobject: '1:7'
(ffff8801276185f8): fill_kobj_path: path = '/devices/virtual/bdi/1:7'
Dec  6 11:42:22 debian-hell kernel: [    8.102762] kobject: '1:8'
(ffff880127618a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102773] kobject: '1:8'
(ffff880127618a40): fill_kobj_path: path = '/devices/virtual/bdi/1:8'
Dec  6 11:42:22 debian-hell kernel: [    8.102806] kobject: '1:9'
(ffff880127618e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102818] kobject: '1:9'
(ffff880127618e88): fill_kobj_path: path = '/devices/virtual/bdi/1:9'
Dec  6 11:42:22 debian-hell kernel: [    8.102851] kobject: '8:0'
(ffff880127a1f990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102862] kobject: '8:0'
(ffff880127a1f990): fill_kobj_path: path = '/devices/virtual/bdi/8:0'
Dec  6 11:42:22 debian-hell kernel: [    8.102895] kobject: '8:16'
(ffff8801270b5750): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102907] kobject: '8:16'
(ffff8801270b5750): fill_kobj_path: path = '/devices/virtual/bdi/8:16'
Dec  6 11:42:22 debian-hell kernel: [    8.102940] kobject: 'default'
(ffff88012fa7f990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102952] kobject: 'default'
(ffff88012fa7f990): fill_kobj_path: path =
'/devices/virtual/bdi/default'
Dec  6 11:42:22 debian-hell kernel: [    8.102985] kobject: 'ram0'
(ffff880129dd54e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.102996] kobject: 'ram0'
(ffff880129dd54e8): fill_kobj_path: path =
'/devices/virtual/block/ram0'
Dec  6 11:42:22 debian-hell kernel: [    8.103031] kobject: 'ram1'
(ffff880129dd5d30): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103043] kobject: 'ram1'
(ffff880129dd5d30): fill_kobj_path: path =
'/devices/virtual/block/ram1'
Dec  6 11:42:22 debian-hell kernel: [    8.103078] kobject: 'ram10'
(ffff880127602b80): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103089] kobject: 'ram10'
(ffff880127602b80): fill_kobj_path: path =
'/devices/virtual/block/ram10'
Dec  6 11:42:22 debian-hell kernel: [    8.103125] kobject: 'ram11'
(ffff8801276033c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103136] kobject: 'ram11'
(ffff8801276033c8): fill_kobj_path: path =
'/devices/virtual/block/ram11'
Dec  6 11:42:22 debian-hell kernel: [    8.103171] kobject: 'ram12'
(ffff880127603c10): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103182] kobject: 'ram12'
(ffff880127603c10): fill_kobj_path: path =
'/devices/virtual/block/ram12'
Dec  6 11:42:22 debian-hell kernel: [    8.103218] kobject: 'ram13'
(ffff880127604458): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103230] kobject: 'ram13'
(ffff880127604458): fill_kobj_path: path =
'/devices/virtual/block/ram13'
Dec  6 11:42:22 debian-hell kernel: [    8.103265] kobject: 'ram14'
(ffff880127604ca0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103276] kobject: 'ram14'
(ffff880127604ca0): fill_kobj_path: path =
'/devices/virtual/block/ram14'
Dec  6 11:42:22 debian-hell kernel: [    8.103311] kobject: 'ram15'
(ffff8801276054e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103323] kobject: 'ram15'
(ffff8801276054e8): fill_kobj_path: path =
'/devices/virtual/block/ram15'
Dec  6 11:42:22 debian-hell kernel: [    8.103363] kobject: 'ram2'
(ffff880129dd6578): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103375] kobject: 'ram2'
(ffff880129dd6578): fill_kobj_path: path =
'/devices/virtual/block/ram2'
Dec  6 11:42:22 debian-hell kernel: [    8.103415] kobject: 'ram3'
(ffff880129dd6dc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103426] kobject: 'ram3'
(ffff880129dd6dc0): fill_kobj_path: path =
'/devices/virtual/block/ram3'
Dec  6 11:42:22 debian-hell kernel: [    8.103461] kobject: 'ram4'
(ffff880129dd7608): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103473] kobject: 'ram4'
(ffff880129dd7608): fill_kobj_path: path =
'/devices/virtual/block/ram4'
Dec  6 11:42:22 debian-hell kernel: [    8.103508] kobject: 'ram5'
(ffff880127600218): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103520] kobject: 'ram5'
(ffff880127600218): fill_kobj_path: path =
'/devices/virtual/block/ram5'
Dec  6 11:42:22 debian-hell kernel: [    8.103554] kobject: 'ram6'
(ffff880127600a60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103566] kobject: 'ram6'
(ffff880127600a60): fill_kobj_path: path =
'/devices/virtual/block/ram6'
Dec  6 11:42:22 debian-hell kernel: [    8.103601] kobject: 'ram7'
(ffff8801276012a8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103613] kobject: 'ram7'
(ffff8801276012a8): fill_kobj_path: path =
'/devices/virtual/block/ram7'
Dec  6 11:42:22 debian-hell kernel: [    8.103648] kobject: 'ram8'
(ffff880127601af0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103659] kobject: 'ram8'
(ffff880127601af0): fill_kobj_path: path =
'/devices/virtual/block/ram8'
Dec  6 11:42:22 debian-hell kernel: [    8.103695] kobject: 'ram9'
(ffff880127602338): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103706] kobject: 'ram9'
(ffff880127602338): fill_kobj_path: path =
'/devices/virtual/block/ram9'
Dec  6 11:42:22 debian-hell kernel: [    8.103742] kobject: 'id'
(ffff88012fa7f548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103753] kobject: 'id'
(ffff88012fa7f548): fill_kobj_path: path = '/devices/virtual/dmi/id'
Dec  6 11:42:22 debian-hell kernel: [    8.103811] kobject: 'fbcon'
(ffff880127938a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103823] kobject: 'fbcon'
(ffff880127938a40): fill_kobj_path: path =
'/devices/virtual/graphics/fbcon'
Dec  6 11:42:22 debian-hell kernel: [    8.103858] kobject: 'hidraw0'
(ffff880127671b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103869] kobject: 'hidraw0'
(ffff880127671b60): fill_kobj_path: path =
'/devices/virtual/hidraw/hidraw0'
Dec  6 11:42:22 debian-hell kernel: [    8.103906] kobject: 'input0'
(ffff8801274d8930): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103917] kobject: 'input0'
(ffff8801274d8930): fill_kobj_path: path =
'/devices/virtual/input/input0'
Dec  6 11:42:22 debian-hell kernel: [    8.103960] kobject: 'mouse0'
(ffff880127606ed8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.103972] kobject: 'mouse0'
(ffff880127606ed8): fill_kobj_path: path =
'/devices/virtual/input/input0/mouse0'
Dec  6 11:42:22 debian-hell kernel: [    8.104006] kobject: 'mice'
(ffff880127606690): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104017] kobject: 'mice'
(ffff880127606690): fill_kobj_path: path =
'/devices/virtual/input/mice'
Dec  6 11:42:22 debian-hell kernel: [    8.104052] kobject: 'full'
(ffff88012f2d2838): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104063] kobject: 'full'
(ffff88012f2d2838): fill_kobj_path: path = '/devices/virtual/mem/full'
Dec  6 11:42:22 debian-hell kernel: [    8.104098] kobject: 'kmem'
(ffff88012f2d1718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104109] kobject: 'kmem'
(ffff88012f2d1718): fill_kobj_path: path = '/devices/virtual/mem/kmem'
Dec  6 11:42:22 debian-hell kernel: [    8.104143] kobject: 'kmsg'
(ffff88012f2d3510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104155] kobject: 'kmsg'
(ffff88012f2d3510): fill_kobj_path: path = '/devices/virtual/mem/kmsg'
Dec  6 11:42:22 debian-hell kernel: [    8.104189] kobject: 'mem'
(ffff88012f2d12d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104200] kobject: 'mem'
(ffff88012f2d12d0): fill_kobj_path: path = '/devices/virtual/mem/mem'
Dec  6 11:42:22 debian-hell kernel: [    8.104234] kobject: 'null'
(ffff88012f2d1b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104246] kobject: 'null'
(ffff88012f2d1b60): fill_kobj_path: path = '/devices/virtual/mem/null'
Dec  6 11:42:22 debian-hell kernel: [    8.104280] kobject: 'port'
(ffff88012f2d1fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104292] kobject: 'port'
(ffff88012f2d1fa8): fill_kobj_path: path = '/devices/virtual/mem/port'
Dec  6 11:42:22 debian-hell kernel: [    8.104326] kobject: 'random'
(ffff88012f2d2c80): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104338] kobject: 'random'
(ffff88012f2d2c80): fill_kobj_path: path =
'/devices/virtual/mem/random'
Dec  6 11:42:22 debian-hell kernel: [    8.104378] kobject: 'urandom'
(ffff88012f2d30c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104390] kobject: 'urandom'
(ffff88012f2d30c8): fill_kobj_path: path =
'/devices/virtual/mem/urandom'
Dec  6 11:42:22 debian-hell kernel: [    8.104428] kobject: 'zero'
(ffff88012f2d23f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104440] kobject: 'zero'
(ffff88012f2d23f0): fill_kobj_path: path = '/devices/virtual/mem/zero'
Dec  6 11:42:22 debian-hell kernel: [    8.104475] kobject:
'cpu_dma_latency' (ffff88012761b958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104486] kobject:
'cpu_dma_latency' (ffff88012761b958): fill_kobj_path: path =
'/devices/virtual/misc/cpu_dma_latency'
Dec  6 11:42:22 debian-hell kernel: [    8.104522] kobject: 'hpet'
(ffff88012754c630): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104533] kobject: 'hpet'
(ffff88012754c630): fill_kobj_path: path =
'/devices/virtual/misc/hpet'
Dec  6 11:42:22 debian-hell kernel: [    8.104573] kobject: 'mcelog'
(ffff880127a181b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104584] kobject: 'mcelog'
(ffff880127a181b0): fill_kobj_path: path =
'/devices/virtual/misc/mcelog'
Dec  6 11:42:22 debian-hell kernel: [    8.104619] kobject:
'network_latency' (ffff88012761bda0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104630] kobject:
'network_latency' (ffff88012761bda0): fill_kobj_path: path =
'/devices/virtual/misc/network_latency'
Dec  6 11:42:22 debian-hell kernel: [    8.104666] kobject:
'network_throughput' (ffff88012761c1e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104678] kobject:
'network_throughput' (ffff88012761c1e8): fill_kobj_path: path =
'/devices/virtual/misc/network_throughput'
Dec  6 11:42:22 debian-hell kernel: [    8.104714] kobject: 'psaux'
(ffff88012761b510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104725] kobject: 'psaux'
(ffff88012761b510): fill_kobj_path: path =
'/devices/virtual/misc/psaux'
Dec  6 11:42:22 debian-hell kernel: [    8.104761] kobject: 'lo'
(ffff88012f2c3808): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104772] kobject: 'lo'
(ffff88012f2c3808): fill_kobj_path: path = '/devices/virtual/net/lo'
Dec  6 11:42:22 debian-hell kernel: [    8.104807] kobject:
'cooling_device0' (ffff88012761ced8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104819] kobject:
'cooling_device0' (ffff88012761ced8): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device0'
Dec  6 11:42:22 debian-hell kernel: [    8.104855] kobject:
'cooling_device1' (ffff8801270981c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104866] kobject:
'cooling_device1' (ffff8801270981c8): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device1'
Dec  6 11:42:22 debian-hell kernel: [    8.104902] kobject:
'cooling_device2' (ffff8801270b01c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104914] kobject:
'cooling_device2' (ffff8801270b01c8): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device2'
Dec  6 11:42:22 debian-hell kernel: [    8.104949] kobject:
'cooling_device3' (ffff8801274f01c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.104961] kobject:
'cooling_device3' (ffff8801274f01c8): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device3'
Dec  6 11:42:22 debian-hell kernel: [    8.104996] kobject:
'cooling_device4' (ffff880127670610): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105008] kobject:
'cooling_device4' (ffff880127670610): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device4'
Dec  6 11:42:22 debian-hell kernel: [    8.105043] kobject:
'cooling_device5' (ffff880127410610): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105055] kobject:
'cooling_device5' (ffff880127410610): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device5'
Dec  6 11:42:22 debian-hell kernel: [    8.105098] kobject:
'cooling_device6' (ffff8801277501c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105110] kobject:
'cooling_device6' (ffff8801277501c8): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device6'
Dec  6 11:42:22 debian-hell kernel: [    8.105146] kobject:
'cooling_device7' (ffff880127a18a58): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105157] kobject:
'cooling_device7' (ffff880127a18a58): fill_kobj_path: path =
'/devices/virtual/thermal/cooling_device7'
Dec  6 11:42:22 debian-hell kernel: [    8.105193] kobject: 'console'
(ffff880127939718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105205] kobject: 'console'
(ffff880127939718): fill_kobj_path: path =
'/devices/virtual/tty/console'
Dec  6 11:42:22 debian-hell kernel: [    8.105239] kobject: 'ptmx'
(ffff880127939b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105259] kobject: 'ptmx'
(ffff880127939b60): fill_kobj_path: path = '/devices/virtual/tty/ptmx'
Dec  6 11:42:22 debian-hell kernel: [    8.105295] kobject: 'tty'
(ffff8801279392d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105306] kobject: 'tty'
(ffff8801279392d0): fill_kobj_path: path = '/devices/virtual/tty/tty'
Dec  6 11:42:22 debian-hell kernel: [    8.105340] kobject: 'tty0'
(ffff880127939fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105351] kobject: 'tty0'
(ffff880127939fa8): fill_kobj_path: path = '/devices/virtual/tty/tty0'
Dec  6 11:42:22 debian-hell kernel: [    8.105386] kobject: 'tty1'
(ffff88012793ac80): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105397] kobject: 'tty1'
(ffff88012793ac80): fill_kobj_path: path = '/devices/virtual/tty/tty1'
Dec  6 11:42:22 debian-hell kernel: [    8.105436] kobject: 'tty10'
(ffff88012793d308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105447] kobject: 'tty10'
(ffff88012793d308): fill_kobj_path: path =
'/devices/virtual/tty/tty10'
Dec  6 11:42:22 debian-hell kernel: [    8.105481] kobject: 'tty11'
(ffff88012793d750): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105492] kobject: 'tty11'
(ffff88012793d750): fill_kobj_path: path =
'/devices/virtual/tty/tty11'
Dec  6 11:42:22 debian-hell kernel: [    8.105527] kobject: 'tty12'
(ffff88012793db98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105538] kobject: 'tty12'
(ffff88012793db98): fill_kobj_path: path =
'/devices/virtual/tty/tty12'
Dec  6 11:42:22 debian-hell kernel: [    8.105573] kobject: 'tty13'
(ffff88012793dfe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105584] kobject: 'tty13'
(ffff88012793dfe0): fill_kobj_path: path =
'/devices/virtual/tty/tty13'
Dec  6 11:42:22 debian-hell kernel: [    8.105618] kobject: 'tty14'
(ffff88012793e428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105629] kobject: 'tty14'
(ffff88012793e428): fill_kobj_path: path =
'/devices/virtual/tty/tty14'
Dec  6 11:42:22 debian-hell kernel: [    8.105664] kobject: 'tty15'
(ffff88012793e870): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105675] kobject: 'tty15'
(ffff88012793e870): fill_kobj_path: path =
'/devices/virtual/tty/tty15'
Dec  6 11:42:22 debian-hell kernel: [    8.105709] kobject: 'tty16'
(ffff88012793ecb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105721] kobject: 'tty16'
(ffff88012793ecb8): fill_kobj_path: path =
'/devices/virtual/tty/tty16'
Dec  6 11:42:22 debian-hell kernel: [    8.105761] kobject: 'tty17'
(ffff88012793f100): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105772] kobject: 'tty17'
(ffff88012793f100): fill_kobj_path: path =
'/devices/virtual/tty/tty17'
Dec  6 11:42:22 debian-hell kernel: [    8.105806] kobject: 'tty18'
(ffff88012793f548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105818] kobject: 'tty18'
(ffff88012793f548): fill_kobj_path: path =
'/devices/virtual/tty/tty18'
Dec  6 11:42:22 debian-hell kernel: [    8.105852] kobject: 'tty19'
(ffff88012793f990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105864] kobject: 'tty19'
(ffff88012793f990): fill_kobj_path: path =
'/devices/virtual/tty/tty19'
Dec  6 11:42:22 debian-hell kernel: [    8.105898] kobject: 'tty2'
(ffff88012793b0c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105909] kobject: 'tty2'
(ffff88012793b0c8): fill_kobj_path: path = '/devices/virtual/tty/tty2'
Dec  6 11:42:22 debian-hell kernel: [    8.105944] kobject: 'tty20'
(ffff88012ecd01b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.105955] kobject: 'tty20'
(ffff88012ecd01b0): fill_kobj_path: path =
'/devices/virtual/tty/tty20'
Dec  6 11:42:22 debian-hell kernel: [    8.105990] kobject: 'tty21'
(ffff88012ecd05f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106001] kobject: 'tty21'
(ffff88012ecd05f8): fill_kobj_path: path =
'/devices/virtual/tty/tty21'
Dec  6 11:42:22 debian-hell kernel: [    8.106035] kobject: 'tty22'
(ffff88012ecd0a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106047] kobject: 'tty22'
(ffff88012ecd0a40): fill_kobj_path: path =
'/devices/virtual/tty/tty22'
Dec  6 11:42:22 debian-hell kernel: [    8.106081] kobject: 'tty23'
(ffff88012ecd0e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106092] kobject: 'tty23'
(ffff88012ecd0e88): fill_kobj_path: path =
'/devices/virtual/tty/tty23'
Dec  6 11:42:22 debian-hell kernel: [    8.106127] kobject: 'tty24'
(ffff88012ecd12d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106138] kobject: 'tty24'
(ffff88012ecd12d0): fill_kobj_path: path =
'/devices/virtual/tty/tty24'
Dec  6 11:42:22 debian-hell kernel: [    8.106173] kobject: 'tty25'
(ffff88012ecd1718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106184] kobject: 'tty25'
(ffff88012ecd1718): fill_kobj_path: path =
'/devices/virtual/tty/tty25'
Dec  6 11:42:22 debian-hell kernel: [    8.106224] kobject: 'tty26'
(ffff88012ecd1b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106235] kobject: 'tty26'
(ffff88012ecd1b60): fill_kobj_path: path =
'/devices/virtual/tty/tty26'
Dec  6 11:42:22 debian-hell kernel: [    8.106270] kobject: 'tty27'
(ffff88012ecd1fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106282] kobject: 'tty27'
(ffff88012ecd1fa8): fill_kobj_path: path =
'/devices/virtual/tty/tty27'
Dec  6 11:42:22 debian-hell kernel: [    8.106315] kobject: 'tty28'
(ffff88012ecd23f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106327] kobject: 'tty28'
(ffff88012ecd23f0): fill_kobj_path: path =
'/devices/virtual/tty/tty28'
Dec  6 11:42:22 debian-hell kernel: [    8.106361] kobject: 'tty29'
(ffff88012ecd2838): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106372] kobject: 'tty29'
(ffff88012ecd2838): fill_kobj_path: path =
'/devices/virtual/tty/tty29'
Dec  6 11:42:22 debian-hell kernel: [    8.106411] kobject: 'tty3'
(ffff88012793b510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106423] kobject: 'tty3'
(ffff88012793b510): fill_kobj_path: path = '/devices/virtual/tty/tty3'
Dec  6 11:42:22 debian-hell kernel: [    8.106457] kobject: 'tty30'
(ffff88012ecd2c80): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106468] kobject: 'tty30'
(ffff88012ecd2c80): fill_kobj_path: path =
'/devices/virtual/tty/tty30'
Dec  6 11:42:22 debian-hell kernel: [    8.106502] kobject: 'tty31'
(ffff88012ecd30c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106514] kobject: 'tty31'
(ffff88012ecd30c8): fill_kobj_path: path =
'/devices/virtual/tty/tty31'
Dec  6 11:42:22 debian-hell kernel: [    8.106548] kobject: 'tty32'
(ffff88012ecd3510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106560] kobject: 'tty32'
(ffff88012ecd3510): fill_kobj_path: path =
'/devices/virtual/tty/tty32'
Dec  6 11:42:22 debian-hell kernel: [    8.106594] kobject: 'tty33'
(ffff88012ecd3958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106605] kobject: 'tty33'
(ffff88012ecd3958): fill_kobj_path: path =
'/devices/virtual/tty/tty33'
Dec  6 11:42:22 debian-hell kernel: [    8.106639] kobject: 'tty34'
(ffff88012ecd3da0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106651] kobject: 'tty34'
(ffff88012ecd3da0): fill_kobj_path: path =
'/devices/virtual/tty/tty34'
Dec  6 11:42:22 debian-hell kernel: [    8.106685] kobject: 'tty35'
(ffff88012ecd41e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106696] kobject: 'tty35'
(ffff88012ecd41e8): fill_kobj_path: path =
'/devices/virtual/tty/tty35'
Dec  6 11:42:22 debian-hell kernel: [    8.106731] kobject: 'tty36'
(ffff88012ecd4630): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106742] kobject: 'tty36'
(ffff88012ecd4630): fill_kobj_path: path =
'/devices/virtual/tty/tty36'
Dec  6 11:42:22 debian-hell kernel: [    8.106776] kobject: 'tty37'
(ffff88012ecd4a78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106788] kobject: 'tty37'
(ffff88012ecd4a78): fill_kobj_path: path =
'/devices/virtual/tty/tty37'
Dec  6 11:42:22 debian-hell kernel: [    8.106822] kobject: 'tty38'
(ffff88012ecd4ec0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106833] kobject: 'tty38'
(ffff88012ecd4ec0): fill_kobj_path: path =
'/devices/virtual/tty/tty38'
Dec  6 11:42:22 debian-hell kernel: [    8.106868] kobject: 'tty39'
(ffff88012ecd5308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106879] kobject: 'tty39'
(ffff88012ecd5308): fill_kobj_path: path =
'/devices/virtual/tty/tty39'
Dec  6 11:42:22 debian-hell kernel: [    8.106918] kobject: 'tty4'
(ffff88012793b958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106930] kobject: 'tty4'
(ffff88012793b958): fill_kobj_path: path = '/devices/virtual/tty/tty4'
Dec  6 11:42:22 debian-hell kernel: [    8.106964] kobject: 'tty40'
(ffff88012ecd5750): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.106976] kobject: 'tty40'
(ffff88012ecd5750): fill_kobj_path: path =
'/devices/virtual/tty/tty40'
Dec  6 11:42:22 debian-hell kernel: [    8.107010] kobject: 'tty41'
(ffff88012ecd5b98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107022] kobject: 'tty41'
(ffff88012ecd5b98): fill_kobj_path: path =
'/devices/virtual/tty/tty41'
Dec  6 11:42:22 debian-hell kernel: [    8.107056] kobject: 'tty42'
(ffff88012ecd5fe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107067] kobject: 'tty42'
(ffff88012ecd5fe0): fill_kobj_path: path =
'/devices/virtual/tty/tty42'
Dec  6 11:42:22 debian-hell kernel: [    8.107102] kobject: 'tty43'
(ffff88012ecd6428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107113] kobject: 'tty43'
(ffff88012ecd6428): fill_kobj_path: path =
'/devices/virtual/tty/tty43'
Dec  6 11:42:22 debian-hell kernel: [    8.107147] kobject: 'tty44'
(ffff88012ecd6870): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107159] kobject: 'tty44'
(ffff88012ecd6870): fill_kobj_path: path =
'/devices/virtual/tty/tty44'
Dec  6 11:42:22 debian-hell kernel: [    8.107193] kobject: 'tty45'
(ffff88012ecd6cb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107204] kobject: 'tty45'
(ffff88012ecd6cb8): fill_kobj_path: path =
'/devices/virtual/tty/tty45'
Dec  6 11:42:22 debian-hell kernel: [    8.107238] kobject: 'tty46'
(ffff88012ecd7100): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107250] kobject: 'tty46'
(ffff88012ecd7100): fill_kobj_path: path =
'/devices/virtual/tty/tty46'
Dec  6 11:42:22 debian-hell kernel: [    8.107284] kobject: 'tty47'
(ffff88012ecd7548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107295] kobject: 'tty47'
(ffff88012ecd7548): fill_kobj_path: path =
'/devices/virtual/tty/tty47'
Dec  6 11:42:22 debian-hell kernel: [    8.107329] kobject: 'tty48'
(ffff88012ecd7990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107340] kobject: 'tty48'
(ffff88012ecd7990): fill_kobj_path: path =
'/devices/virtual/tty/tty48'
Dec  6 11:42:22 debian-hell kernel: [    8.107379] kobject: 'tty49'
(ffff8801275481b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107390] kobject: 'tty49'
(ffff8801275481b0): fill_kobj_path: path =
'/devices/virtual/tty/tty49'
Dec  6 11:42:22 debian-hell kernel: [    8.107424] kobject: 'tty5'
(ffff88012793bda0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107436] kobject: 'tty5'
(ffff88012793bda0): fill_kobj_path: path = '/devices/virtual/tty/tty5'
Dec  6 11:42:22 debian-hell kernel: [    8.107470] kobject: 'tty50'
(ffff8801275485f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107481] kobject: 'tty50'
(ffff8801275485f8): fill_kobj_path: path =
'/devices/virtual/tty/tty50'
Dec  6 11:42:22 debian-hell kernel: [    8.107521] kobject: 'tty51'
(ffff880127548a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107533] kobject: 'tty51'
(ffff880127548a40): fill_kobj_path: path =
'/devices/virtual/tty/tty51'
Dec  6 11:42:22 debian-hell kernel: [    8.107567] kobject: 'tty52'
(ffff880127548e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107578] kobject: 'tty52'
(ffff880127548e88): fill_kobj_path: path =
'/devices/virtual/tty/tty52'
Dec  6 11:42:22 debian-hell kernel: [    8.107613] kobject: 'tty53'
(ffff8801275492d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107624] kobject: 'tty53'
(ffff8801275492d0): fill_kobj_path: path =
'/devices/virtual/tty/tty53'
Dec  6 11:42:22 debian-hell kernel: [    8.107658] kobject: 'tty54'
(ffff880127549718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107670] kobject: 'tty54'
(ffff880127549718): fill_kobj_path: path =
'/devices/virtual/tty/tty54'
Dec  6 11:42:22 debian-hell kernel: [    8.107704] kobject: 'tty55'
(ffff880127549b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107715] kobject: 'tty55'
(ffff880127549b60): fill_kobj_path: path =
'/devices/virtual/tty/tty55'
Dec  6 11:42:22 debian-hell kernel: [    8.107749] kobject: 'tty56'
(ffff880127549fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107761] kobject: 'tty56'
(ffff880127549fa8): fill_kobj_path: path =
'/devices/virtual/tty/tty56'
Dec  6 11:42:22 debian-hell kernel: [    8.107795] kobject: 'tty57'
(ffff88012754a3f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107806] kobject: 'tty57'
(ffff88012754a3f0): fill_kobj_path: path =
'/devices/virtual/tty/tty57'
Dec  6 11:42:22 debian-hell kernel: [    8.107841] kobject: 'tty58'
(ffff88012754a838): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107852] kobject: 'tty58'
(ffff88012754a838): fill_kobj_path: path =
'/devices/virtual/tty/tty58'
Dec  6 11:42:22 debian-hell kernel: [    8.107887] kobject: 'tty59'
(ffff88012754ac80): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107898] kobject: 'tty59'
(ffff88012754ac80): fill_kobj_path: path =
'/devices/virtual/tty/tty59'
Dec  6 11:42:22 debian-hell kernel: [    8.107932] kobject: 'tty6'
(ffff88012793c1e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107943] kobject: 'tty6'
(ffff88012793c1e8): fill_kobj_path: path = '/devices/virtual/tty/tty6'
Dec  6 11:42:22 debian-hell kernel: [    8.107977] kobject: 'tty60'
(ffff88012754b0c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.107988] kobject: 'tty60'
(ffff88012754b0c8): fill_kobj_path: path =
'/devices/virtual/tty/tty60'
Dec  6 11:42:22 debian-hell kernel: [    8.108023] kobject: 'tty61'
(ffff88012754b510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108034] kobject: 'tty61'
(ffff88012754b510): fill_kobj_path: path =
'/devices/virtual/tty/tty61'
Dec  6 11:42:22 debian-hell kernel: [    8.108074] kobject: 'tty62'
(ffff88012754b958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108085] kobject: 'tty62'
(ffff88012754b958): fill_kobj_path: path =
'/devices/virtual/tty/tty62'
Dec  6 11:42:22 debian-hell kernel: [    8.108119] kobject: 'tty63'
(ffff88012754bda0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108130] kobject: 'tty63'
(ffff88012754bda0): fill_kobj_path: path =
'/devices/virtual/tty/tty63'
Dec  6 11:42:22 debian-hell kernel: [    8.108164] kobject: 'tty7'
(ffff88012793c630): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108176] kobject: 'tty7'
(ffff88012793c630): fill_kobj_path: path = '/devices/virtual/tty/tty7'
Dec  6 11:42:22 debian-hell kernel: [    8.108209] kobject: 'tty8'
(ffff88012793ca78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108221] kobject: 'tty8'
(ffff88012793ca78): fill_kobj_path: path = '/devices/virtual/tty/tty8'
Dec  6 11:42:22 debian-hell kernel: [    8.108255] kobject: 'tty9'
(ffff88012793cec0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108267] kobject: 'tty9'
(ffff88012793cec0): fill_kobj_path: path = '/devices/virtual/tty/tty9'
Dec  6 11:42:22 debian-hell kernel: [    8.108301] kobject: 'usbmon0'
(ffff88012761ac80): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108312] kobject: 'usbmon0'
(ffff88012761ac80): fill_kobj_path: path =
'/devices/virtual/usbmon/usbmon0'
Dec  6 11:42:22 debian-hell kernel: [    8.108353] kobject: 'vcs'
(ffff88012793a3f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108364] kobject: 'vcs'
(ffff88012793a3f0): fill_kobj_path: path = '/devices/virtual/vc/vcs'
Dec  6 11:42:22 debian-hell kernel: [    8.108399] kobject: 'vcs1'
(ffff880126e630c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108410] kobject: 'vcs1'
(ffff880126e630c8): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [    8.108444] kobject: 'vcsa'
(ffff88012793a838): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108455] kobject: 'vcsa'
(ffff88012793a838): fill_kobj_path: path = '/devices/virtual/vc/vcsa'
Dec  6 11:42:22 debian-hell kernel: [    8.108490] kobject: 'vcsa1'
(ffff880126e63da0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108501] kobject: 'vcsa1'
(ffff880126e63da0): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [    8.108535] kobject: 'vtcon0'
(ffff88012fa7f100): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.108547] kobject: 'vtcon0'
(ffff88012fa7f100): fill_kobj_path: path =
'/devices/virtual/vtconsole/vtcon0'
Dec  6 11:42:22 debian-hell kernel: [    8.386574] kobject:
'snd_page_alloc' (ffffffffa015e250): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.388164] kobject: 'holders'
(ffff8801291facc0): kobject_add_internal: parent: 'snd_page_alloc',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.388178] kobject:
'snd_page_alloc' (ffffffffa015e250): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.388206] kobject:
'snd_page_alloc' (ffffffffa015e250): fill_kobj_path: path =
'/module/snd_page_alloc'
Dec  6 11:42:22 debian-hell kernel: [    8.388291] kobject: 'notes'
(ffff8801291fac38): kobject_add_internal: parent: 'snd_page_alloc',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.395082] kobject:
'soundcore' (ffffffffa0162d50): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.396833] kobject: 'holders'
(ffff8801291fae58): kobject_add_internal: parent: 'soundcore', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.396854] kobject:
'soundcore' (ffffffffa0162d50): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.396871] kobject:
'soundcore' (ffffffffa0162d50): fill_kobj_path: path =
'/module/soundcore'
Dec  6 11:42:22 debian-hell kernel: [    8.396937] kobject: 'notes'
(ffff8801291faee0): kobject_add_internal: parent: 'soundcore', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.396976] kobject: 'sound'
(ffff8801279514d0): kobject_add_internal: parent: 'class', set:
'class'
Dec  6 11:42:22 debian-hell kernel: [    8.396987] kobject: 'sound'
(ffff8801279514d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.397002] kobject: 'sound'
(ffff8801279514d0): fill_kobj_path: path = '/class/sound'
Dec  6 11:42:22 debian-hell kernel: [    8.437367] kobject: 'button'
(ffffffffa0166bd0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.438478] kobject: 'holders'
(ffff880126d72660): kobject_add_internal: parent: 'button', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.438488] kobject: 'button'
(ffffffffa0166bd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.438499] kobject: 'button'
(ffffffffa0166bd0): fill_kobj_path: path = '/module/button'
Dec  6 11:42:22 debian-hell kernel: [    8.438560] kobject: 'notes'
(ffff880126d72990): kobject_add_internal: parent: 'button', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.438596] kobject: 'button'
(ffff880127900490): kobject_add_internal: parent: 'drivers', set:
'drivers'
Dec  6 11:42:22 debian-hell kernel: [    8.438668] kobject: 'input'
(ffff880126d72088): kobject_add_internal: parent: 'LNXPWRBN:00', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.438677] kobject: 'input3'
(ffff88012790a9c0): kobject_add_internal: parent: 'input', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.438749] PM: Adding info for
No Bus:input3
Dec  6 11:42:22 debian-hell kernel: [    8.438752] kobject: 'input3'
(ffff88012790a9c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.438766] kobject: 'input3'
(ffff88012790a9c0): fill_kobj_path: path =
'/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3'
Dec  6 11:42:22 debian-hell kernel: [    8.438796] kobject: 'input3'
(ffff88012790a9c0): fill_kobj_path: path =
'/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3'
Dec  6 11:42:22 debian-hell kernel: [    8.438799] input: Power Button
(FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Dec  6 11:42:22 debian-hell kernel: [    8.460473] ACPI: Power Button
(FF) [PWRF]
Dec  6 11:42:22 debian-hell kernel: [    8.460595] kobject: 'input'
(ffff880126c0a198): kobject_add_internal: parent: 'PNP0C0C:00', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.460603] kobject: 'input4'
(ffff880127909978): kobject_add_internal: parent: 'input', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.460682] PM: Adding info for
No Bus:input4
Dec  6 11:42:22 debian-hell kernel: [    8.460686] kobject: 'input4'
(ffff880127909978): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.460700] kobject: 'input4'
(ffff880127909978): fill_kobj_path: path =
'/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4'
Dec  6 11:42:22 debian-hell kernel: [    8.460733] kobject: 'input4'
(ffff880127909978): fill_kobj_path: path =
'/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4'
Dec  6 11:42:22 debian-hell kernel: [    8.460737] input: Power Button
(CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
Dec  6 11:42:22 debian-hell kernel: [    8.461566] kobject: 'wmi'
(ffffffffa016abd0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.464237] kobject: 'holders'
(ffff880126cd3000): kobject_add_internal: parent: 'wmi', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.464249] kobject: 'wmi'
(ffffffffa016abd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.464265] kobject: 'wmi'
(ffffffffa016abd0): fill_kobj_path: path = '/module/wmi'
Dec  6 11:42:22 debian-hell kernel: [    8.464340] kobject: 'notes'
(ffff880126cd3220): kobject_add_internal: parent: 'wmi', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.464368] kobject: 'wmi'
(ffff880127972238): kobject_add_internal: parent: 'drivers', set:
'drivers'
Dec  6 11:42:22 debian-hell kernel: [    8.492390] ACPI: Power Button
(CM) [PWRB]
Dec  6 11:42:22 debian-hell kernel: [    8.492924] kobject: 'wmi'
(ffff880127972238): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.492931] kobject: 'button'
(ffff880127900490): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.492950] kobject: 'button'
(ffff880127900490): fill_kobj_path: path = '/bus/acpi/drivers/button'
Dec  6 11:42:22 debian-hell kernel: [    8.492948] kobject: 'wmi'
(ffff880127972238): fill_kobj_path: path = '/bus/acpi/drivers/wmi'
Dec  6 11:42:22 debian-hell kernel: [    8.492968] ACPI: WMI: Mapper loaded
Dec  6 11:42:22 debian-hell kernel: [    8.495544] kobject: 'evdev'
(ffffffffa016f9d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.517737] kobject: 'holders'
(ffff8801265ce440): kobject_add_internal: parent: 'evdev', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.517754] kobject: 'evdev'
(ffffffffa016f9d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.517774] kobject: 'evdev'
(ffffffffa016f9d0): fill_kobj_path: path = '/module/evdev'
Dec  6 11:42:22 debian-hell kernel: [    8.517846] kobject: 'notes'
(ffff8801265ce5d8): kobject_add_internal: parent: 'evdev', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.560346] kobject: 'snd'
(ffffffffa0180650): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.564318] kobject: 'event0'
(ffff8801270f6698): kobject_add_internal: parent: 'input0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.564366] PM: Adding info for
No Bus:event0
Dec  6 11:42:22 debian-hell kernel: [    8.564370] kobject: 'event0'
(ffff8801270f6698): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.564389] kobject: 'event0'
(ffff8801270f6698): fill_kobj_path: path =
'/devices/virtual/input/input0/event0'
Dec  6 11:42:22 debian-hell kernel: [    8.566314] kobject: 'holders'
(ffff88012700f990): kobject_add_internal: parent: 'snd', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.566341] kobject: 'snd'
(ffffffffa0180650): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.566351] kobject: 'snd'
(ffffffffa0180650): fill_kobj_path: path = '/module/snd'
Dec  6 11:42:22 debian-hell kernel: [    8.566400] kobject: 'notes'
(ffff88012700fbb0): kobject_add_internal: parent: 'snd', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.597230] kobject: 'pcspkr'
(ffffffffa01849d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.597922] kobject: 'holders'
(ffff880126d667f8): kobject_add_internal: parent: 'pcspkr', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.597938] kobject: 'pcspkr'
(ffffffffa01849d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.597950] kobject: 'pcspkr'
(ffffffffa01849d0): fill_kobj_path: path = '/module/pcspkr'
Dec  6 11:42:22 debian-hell kernel: [    8.598008] kobject: 'notes'
(ffff8801264e2000): kobject_add_internal: parent: 'pcspkr', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.598033] kobject: 'pcspkr'
(ffff880127953908): kobject_add_internal: parent: 'drivers', set:
'drivers'
Dec  6 11:42:22 debian-hell kernel: [    8.598086] kobject: 'input'
(ffff8801264e2088): kobject_add_internal: parent: 'pcspkr', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.598094] kobject: 'input5'
(ffff880125880930): kobject_add_internal: parent: 'input', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.598167] PM: Adding info for
No Bus:input5
Dec  6 11:42:22 debian-hell kernel: [    8.598171] kobject: 'input5'
(ffff880125880930): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.598187] kobject: 'input5'
(ffff880125880930): fill_kobj_path: path =
'/devices/platform/pcspkr/input/input5'
Dec  6 11:42:22 debian-hell kernel: [    8.598219] kobject: 'input5'
(ffff880125880930): fill_kobj_path: path =
'/devices/platform/pcspkr/input/input5'
Dec  6 11:42:22 debian-hell kernel: [    8.598224] input: PC Speaker
as /devices/platform/pcspkr/input/input5
Dec  6 11:42:22 debian-hell kernel: [    8.613521] kobject: 'event1'
(ffff8801270f5e50): kobject_add_internal: parent: 'input1', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.613571] PM: Adding info for
No Bus:event1
Dec  6 11:42:22 debian-hell kernel: [    8.613574] kobject: 'event1'
(ffff8801270f5e50): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.613592] kobject: 'event1'
(ffff8801270f5e50): fill_kobj_path: path =
'/devices/platform/i8042/serio0/input/input1/event1'
Dec  6 11:42:22 debian-hell kernel: [    8.615181] kobject: 'i2c_core'
(ffffffffa018d1d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.619974] kobject: 'holders'
(ffff8801264e2330): kobject_add_internal: parent: 'i2c_core', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.619986] kobject: 'i2c_core'
(ffffffffa018d1d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.620005] kobject: 'i2c_core'
(ffffffffa018d1d0): fill_kobj_path: path = '/module/i2c_core'
Dec  6 11:42:22 debian-hell kernel: [    8.620094] kobject: 'notes'
(ffff8801264e23b8): kobject_add_internal: parent: 'i2c_core', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.620129] kobject: 'i2c'
(ffff880127951718): kobject_add_internal: parent: 'bus', set: 'bus'
Dec  6 11:42:22 debian-hell kernel: [    8.620137] kobject: 'i2c'
(ffff880127951718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.620156] kobject: 'i2c'
(ffff880127951718): fill_kobj_path: path = '/bus/i2c'
Dec  6 11:42:22 debian-hell kernel: [    8.620180] kobject: 'devices'
(ffff8801270c2780): kobject_add_internal: parent: 'i2c', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.620186] kobject: 'devices'
(ffff8801270c2780): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.620189] kobject: 'devices'
(ffff8801270c2780): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [    8.620195] kobject: 'drivers'
(ffff8801270c2888): kobject_add_internal: parent: 'i2c', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.620201] kobject: 'drivers'
(ffff8801270c2888): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.620204] kobject: 'drivers'
(ffff8801270c2888): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [    8.620216] kobject:
'i2c-adapter' (ffff880127950720): kobject_add_internal: parent:
'class', set: 'class'
Dec  6 11:42:22 debian-hell kernel: [    8.620225] kobject:
'i2c-adapter' (ffff880127950720): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.620244] kobject:
'i2c-adapter' (ffff880127950720): fill_kobj_path: path =
'/class/i2c-adapter'
Dec  6 11:42:22 debian-hell kernel: [    8.620267] kobject: 'dummy'
(ffff880127953d98): kobject_add_internal: parent: 'drivers', set:
'drivers'
Dec  6 11:42:22 debian-hell kernel: [    8.620281] kobject: 'drivers'
(ffff8801264e2110): kobject_add_internal: parent: 'i2c_core', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.620298] kobject: 'dummy'
(ffff880127953d98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.620317] kobject: 'dummy'
(ffff880127953d98): fill_kobj_path: path = '/bus/i2c/drivers/dummy'
Dec  6 11:42:22 debian-hell kernel: [    8.634272] kobject: '65534'
(ffff88012699e060): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:42:22 debian-hell kernel: [    8.634280] kobject: '65534'
(ffff88012699e060): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.634292] kobject: '65534'
(ffff88012699e060): fill_kobj_path: path = '/kernel/uids/65534'
Dec  6 11:42:22 debian-hell kernel: [    8.640810] kobject: 'event2'
(ffff8801260f4dc0): kobject_add_internal: parent: 'input2', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.640858] PM: Adding info for
No Bus:event2
Dec  6 11:42:22 debian-hell kernel: [    8.640861] kobject: 'event2'
(ffff8801260f4dc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.640873] kobject: 'event2'
(ffff8801260f4dc0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.0/usb1/1-2/1-2:1.0/input/input2/event2'
Dec  6 11:42:22 debian-hell kernel: [    8.672776] kobject: 'event3'
(ffff8801260f6698): kobject_add_internal: parent: 'input3', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.672824] PM: Adding info for
No Bus:event3
Dec  6 11:42:22 debian-hell kernel: [    8.672827] kobject: 'event3'
(ffff8801260f6698): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.672842] kobject: 'event3'
(ffff8801260f6698): fill_kobj_path: path =
'/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3'
Dec  6 11:42:22 debian-hell kernel: [    8.688923] kobject: 'event4'
(ffff8801260f5e50): kobject_add_internal: parent: 'input4', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.688966] PM: Adding info for
No Bus:event4
Dec  6 11:42:22 debian-hell kernel: [    8.688969] kobject: 'event4'
(ffff8801260f5e50): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.688987] kobject: 'event4'
(ffff8801260f5e50): fill_kobj_path: path =
'/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4/event4'
Dec  6 11:42:22 debian-hell kernel: [    8.727323] kobject:
'snd_seq_device' (ffffffffa0191dd0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.728449] kobject: 'holders'
(ffff880126036660): kobject_add_internal: parent: 'snd_seq_device',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.728459] kobject:
'snd_seq_device' (ffffffffa0191dd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.728470] kobject:
'snd_seq_device' (ffffffffa0191dd0): fill_kobj_path: path =
'/module/snd_seq_device'
Dec  6 11:42:22 debian-hell kernel: [    8.728525] kobject: 'notes'
(ffff8801260365d8): kobject_add_internal: parent: 'snd_seq_device',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.729630] kobject:
'snd_timer' (ffffffffa01996d0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.731925] kobject: 'holders'
(ffff8801288282a8): kobject_add_internal: parent: 'snd_timer', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.731970] kobject:
'snd_timer' (ffffffffa01996d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.731987] kobject:
'snd_timer' (ffffffffa01996d0): fill_kobj_path: path =
'/module/snd_timer'
Dec  6 11:42:22 debian-hell kernel: [    8.732078] kobject: 'notes'
(ffff880128828000): kobject_add_internal: parent: 'snd_timer', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.732122] kobject: 'sound'
(ffff880128828198): kobject_add_internal: parent: 'virtual', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.732133] kobject: 'timer'
(ffff880127417990): kobject_add_internal: parent: 'sound', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.732175] PM: Adding info for
No Bus:timer
Dec  6 11:42:22 debian-hell kernel: [    8.732178] kobject: 'timer'
(ffff880127417990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.732195] kobject: 'timer'
(ffff880127417990): fill_kobj_path: path =
'/devices/virtual/sound/timer'
Dec  6 11:42:22 debian-hell kernel: [    8.736783] kobject: 'event5'
(ffff8801260f2458): kobject_add_internal: parent: 'input5', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.736827] PM: Adding info for
No Bus:event5
Dec  6 11:42:22 debian-hell kernel: [    8.736830] kobject: 'event5'
(ffff8801260f2458): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.736846] kobject: 'event5'
(ffff8801260f2458): fill_kobj_path: path =
'/devices/platform/pcspkr/input/input5/event5'
Dec  6 11:42:22 debian-hell kernel: [    8.736890] kobject: 'drivers'
(ffff8801264e2d48): kobject_add_internal: parent: 'pcspkr', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.736909] kobject: 'pcspkr'
(ffff880127953908): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.736925] kobject: 'pcspkr'
(ffff880127953908): fill_kobj_path: path =
'/bus/platform/drivers/pcspkr'
Dec  6 11:42:22 debian-hell kernel: [    8.877278] usb-storage: device
scan complete
Dec  6 11:42:22 debian-hell kernel: [    8.877846] scsi 3:0:0:0:
CD-ROM            PLEXTOR  DVDR   PX-755A   1.08 PQ: 0 ANSI: 0
Dec  6 11:42:22 debian-hell kernel: [    8.878000] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878002] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878008] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878009] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878012] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878014] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878128] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878130] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878135] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878136] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878139] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878141] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878166] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878167] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878249] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878251] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878256] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878257] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878260] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878262] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878286] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878287] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878368] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878370] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878375] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878376] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878379] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878381] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878404] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878406] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878487] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878489] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878494] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878495] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878498] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878500] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878524] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878525] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878607] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878609] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878614] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878615] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878618] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878620] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878643] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878645] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878732] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878734] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878738] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878740] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878743] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878744] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878769] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878770] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878852] kobject: '<NULL>'
(ffff88012797c448): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878854] kobject: '<NULL>'
(ffff88012797c448): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878858] kobject: '<NULL>'
(ffff880127945d88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878860] kobject: '<NULL>'
(ffff880127945d88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878863] kobject: '<NULL>'
(ffff8801261a8d90): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878865] kobject: '<NULL>'
(ffff8801261a8d90): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878888] kobject: '<NULL>'
(ffff880128d58a20): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    8.878890] kobject: '<NULL>'
(ffff880128d58a20): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    8.878897] kobject:
'target3:0:0' (ffff880128d581d8): kobject_add_internal: parent:
'host3', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.878916] PM: Adding info for
scsi:target3:0:0
Dec  6 11:42:22 debian-hell kernel: [    8.878918] kobject:
'target3:0:0' (ffff880128d581d8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.878931] kobject:
'target3:0:0' (ffff880128d581d8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.878952] kobject: '3:0:0:0'
(ffff88012797b400): kobject_add_internal: parent: 'target3:0:0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.878990] PM: Adding info for
scsi:3:0:0:0
Dec  6 11:42:22 debian-hell kernel: [    8.878992] kobject: '3:0:0:0'
(ffff88012797b400): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.879004] kobject: '3:0:0:0'
(ffff88012797b400): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.879197] kobject: 'i2c_i801'
(ffffffffa019e6d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.880128] kobject: 'holders'
(ffff8801271ea6e8): kobject_add_internal: parent: 'i2c_i801', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.880141] kobject: 'i2c_i801'
(ffffffffa019e6d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.880151] kobject: 'i2c_i801'
(ffffffffa019e6d0): fill_kobj_path: path = '/module/i2c_i801'
Dec  6 11:42:22 debian-hell kernel: [    8.880195] kobject: 'notes'
(ffff8801271eab28): kobject_add_internal: parent: 'i2c_i801', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.880221] kobject:
'i801_smbus' (ffff8801275f1ff0): kobject_add_internal: parent:
'drivers', set: 'drivers'
Dec  6 11:42:22 debian-hell kernel: [    8.880296] i801_smbus
0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Dec  6 11:42:22 debian-hell kernel: [    8.880401] kobject:
'i2c-adapter' (ffff8801271ea2a8): kobject_add_internal: parent:
'0000:00:1f.3', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.880409] kobject: 'i2c-0'
(ffffffffa019e1c0): kobject_add_internal: parent: 'i2c-adapter', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.880441] PM: Adding info for
No Bus:i2c-0
Dec  6 11:42:22 debian-hell kernel: [    8.880443] kobject: 'i2c-0'
(ffffffffa019e1c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.880461] kobject: 'i2c-0'
(ffffffffa019e1c0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0'
Dec  6 11:42:22 debian-hell kernel: [    8.880505] kobject: 'drivers'
(ffff88012710da18): kobject_add_internal: parent: 'i2c_i801', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.880522] kobject:
'i801_smbus' (ffff8801275f1ff0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.880538] kobject:
'i801_smbus' (ffff8801275f1ff0): fill_kobj_path: path =
'/bus/pci/drivers/i801_smbus'
Dec  6 11:42:22 debian-hell kernel: [    8.882967] sr1: scsi3-mmc
drive: 40x/40x writer cd/rw xa/form2 cdda tray
Dec  6 11:42:22 debian-hell kernel: [    8.883037] kobject: 'block'
(ffff8801260e5198): kobject_add_internal: parent: '3:0:0:0', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883048] kobject: 'sr1'
(ffff880128d58a60): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.883099] PM: Adding info for
No Bus:sr1
Dec  6 11:42:22 debian-hell kernel: [    8.883102] kobject: 'sr1'
(ffff880128d58a60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883106] kobject: 'sr1'
(ffff880128d58a60): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [    8.883125] kobject: 'holders'
(ffff8801260e5110): kobject_add_internal: parent: 'sr1', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883133] kobject: 'slaves'
(ffff8801260e52a8): kobject_add_internal: parent: 'sr1', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883139] kobject: 'sr1'
(ffff880128d58a60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883162] kobject: 'sr1'
(ffff880128d58a60): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0/block/sr1'
Dec  6 11:42:22 debian-hell kernel: [    8.883190] kobject: 'queue'
(ffff8801261a83d0): kobject_add_internal: parent: 'sr1', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883212] kobject: 'queue'
(ffff8801261a83d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883215] kobject: 'queue'
(ffff8801261a83d0): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [    8.883220] kobject: 'iosched'
(ffff8801270ee530): kobject_add_internal: parent: 'queue', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883246] kobject: 'iosched'
(ffff8801270ee530): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883249] kobject: 'iosched'
(ffff8801270ee530): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [    8.883260] kobject: '11:1'
(ffff880127098e88): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.883298] PM: Adding info for
No Bus:11:1
Dec  6 11:42:22 debian-hell kernel: [    8.883301] kobject: '11:1'
(ffff880127098e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883320] kobject: '11:1'
(ffff880127098e88): fill_kobj_path: path = '/devices/virtual/bdi/11:1'
Dec  6 11:42:22 debian-hell kernel: [    8.883359] sr 3:0:0:0:
Attached scsi CD-ROM sr1
Dec  6 11:42:22 debian-hell kernel: [    8.883368] kobject:
'scsi_device' (ffff8801260e5330): kobject_add_internal: parent:
'3:0:0:0', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883377] kobject: '3:0:0:0'
(ffff88012797b778): kobject_add_internal: parent: 'scsi_device', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.883398] PM: Adding info for
No Bus:3:0:0:0
Dec  6 11:42:22 debian-hell kernel: [    8.883401] kobject: '3:0:0:0'
(ffff88012797b778): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883417] kobject: '3:0:0:0'
(ffff88012797b778): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0/scsi_device/3:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.883470] kobject:
'scsi_generic' (ffff8801260e54c8): kobject_add_internal: parent:
'3:0:0:0', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883479] kobject: 'sg3'
(ffff8801270992d0): kobject_add_internal: parent: 'scsi_generic', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.883519] PM: Adding info for
No Bus:sg3
Dec  6 11:42:22 debian-hell kernel: [    8.883521] kobject: 'sg3'
(ffff8801270992d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883537] kobject: 'sg3'
(ffff8801270992d0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0/scsi_generic/sg3'
Dec  6 11:42:22 debian-hell kernel: [    8.883566] sr 3:0:0:0:
Attached scsi generic sg3 type 5
Dec  6 11:42:22 debian-hell kernel: [    8.883635] kobject: 'bsg'
(ffff8801260e5550): kobject_add_internal: parent: '3:0:0:0', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.883651] kobject: '3:0:0:0'
(ffff8801270985f8): kobject_add_internal: parent: 'bsg', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.883684] PM: Adding info for
No Bus:3:0:0:0
Dec  6 11:42:22 debian-hell kernel: [    8.883687] kobject: '3:0:0:0'
(ffff8801270985f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.883706] kobject: '3:0:0:0'
(ffff8801270985f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0/bsg/3:0:0:0'
Dec  6 11:42:22 debian-hell kernel: [    8.905093] kobject: 'snd_seq'
(ffffffffa01ad6d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    8.908733] kobject: 'holders'
(ffff880128cd4a18): kobject_add_internal: parent: 'snd_seq', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.908776] kobject: 'snd_seq'
(ffffffffa01ad6d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.908795] kobject: 'snd_seq'
(ffffffffa01ad6d0): fill_kobj_path: path = '/module/snd_seq'
Dec  6 11:42:22 debian-hell kernel: [    8.908872] kobject: 'notes'
(ffff880128cd4aa0): kobject_add_internal: parent: 'snd_seq', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.908912] kobject: 'seq'
(ffff8801270b6cb8): kobject_add_internal: parent: 'sound', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.908954] PM: Adding info for
No Bus:seq
Dec  6 11:42:22 debian-hell kernel: [    8.908957] kobject: 'seq'
(ffff8801270b6cb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.908975] kobject: 'seq'
(ffff8801270b6cb8): fill_kobj_path: path =
'/devices/virtual/sound/seq'
Dec  6 11:42:22 debian-hell kernel: [    8.951594] kobject:
'snd_seq_midi_event' (ffffffffa01b2dd0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.952848] kobject: 'holders'
(ffff880128828220): kobject_add_internal: parent:
'snd_seq_midi_event', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.952861] kobject:
'snd_seq_midi_event' (ffffffffa01b2dd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.952875] kobject:
'snd_seq_midi_event' (ffffffffa01b2dd0): fill_kobj_path: path =
'/module/snd_seq_midi_event'
Dec  6 11:42:22 debian-hell kernel: [    8.952976] kobject: 'notes'
(ffff880128828990): kobject_add_internal: parent:
'snd_seq_midi_event', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.956000] kobject:
'snd_seq_oss' (ffffffffa01bc350): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.973677] kobject: 'holders'
(ffff880128828b28): kobject_add_internal: parent: 'snd_seq_oss', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.973702] kobject:
'snd_seq_oss' (ffffffffa01bc350): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.973720] kobject:
'snd_seq_oss' (ffffffffa01bc350): fill_kobj_path: path =
'/module/snd_seq_oss'
Dec  6 11:42:22 debian-hell kernel: [    8.974457] kobject: 'notes'
(ffff880128828bb0): kobject_add_internal: parent: 'snd_seq_oss', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.974541] kobject:
'sequencer' (ffff880127417548): kobject_add_internal: parent: 'sound',
set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.974588] PM: Adding info for
No Bus:sequencer
Dec  6 11:42:22 debian-hell kernel: [    8.974591] kobject:
'sequencer' (ffff880127417548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.974609] kobject:
'sequencer' (ffff880127417548): fill_kobj_path: path =
'/devices/virtual/sound/sequencer'
Dec  6 11:42:22 debian-hell kernel: [    8.975883] kobject:
'sequencer2' (ffff880127417100): kobject_add_internal: parent:
'sound', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [    8.975914] PM: Adding info for
No Bus:sequencer2
Dec  6 11:42:22 debian-hell kernel: [    8.975917] kobject:
'sequencer2' (ffff880127417100): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.975937] kobject:
'sequencer2' (ffff880127417100): fill_kobj_path: path =
'/devices/virtual/sound/sequencer2'
Dec  6 11:42:22 debian-hell kernel: [    8.999031] kobject:
'snd_seq_dummy' (ffffffffa01bfad0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    8.999765] kobject: 'holders'
(ffff8801271547f8): kobject_add_internal: parent: 'snd_seq_dummy',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    8.999785] kobject:
'snd_seq_dummy' (ffffffffa01bfad0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    8.999797] kobject:
'snd_seq_dummy' (ffffffffa01bfad0): fill_kobj_path: path =
'/module/snd_seq_dummy'
Dec  6 11:42:22 debian-hell kernel: [    9.000296] kobject: 'notes'
(ffff880127154a18): kobject_add_internal: parent: 'snd_seq_dummy',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.000636] kobject: '65534'
(ffff88012699e060): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.000648] kobject: '65534'
(ffff88012699e060): fill_kobj_path: path = '/kernel/uids/65534'
Dec  6 11:42:22 debian-hell kernel: [    9.000675] kobject: '65534'
(ffff88012699e060): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [    9.000677] kobject: '65534'
(ffff88012699e060): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [    9.000679] kobject: '65534': free name
Dec  6 11:42:22 debian-hell kernel: [    9.024833] kobject:
'snd_mixer_oss' (ffffffffa01c5850): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    9.026162] kobject: 'holders'
(ffff880127941220): kobject_add_internal: parent: 'snd_mixer_oss',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.026173] kobject:
'snd_mixer_oss' (ffffffffa01c5850): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.026185] kobject:
'snd_mixer_oss' (ffffffffa01c5850): fill_kobj_path: path =
'/module/snd_mixer_oss'
Dec  6 11:42:22 debian-hell kernel: [    9.026241] kobject: 'notes'
(ffff880127941770): kobject_add_internal: parent: 'snd_mixer_oss',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.050985] kobject: 'snd_pcm'
(ffffffffa01db650): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [    9.056036] kobject: 'holders'
(ffff880127941198): kobject_add_internal: parent: 'snd_pcm', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.056052] kobject: 'snd_pcm'
(ffffffffa01db650): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.056062] kobject: 'snd_pcm'
(ffffffffa01db650): fill_kobj_path: path = '/module/snd_pcm'
Dec  6 11:42:22 debian-hell kernel: [    9.056119] kobject: 'notes'
(ffff880127941088): kobject_add_internal: parent: 'snd_pcm', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.058393] kobject:
'snd_pcm_oss' (ffffffffa01e70d0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    9.060657] kobject: 'holders'
(ffff880127941f68): kobject_add_internal: parent: 'snd_pcm_oss', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.060679] kobject:
'snd_pcm_oss' (ffffffffa01e70d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.060691] kobject:
'snd_pcm_oss' (ffffffffa01e70d0): fill_kobj_path: path =
'/module/snd_pcm_oss'
Dec  6 11:42:22 debian-hell kernel: [    9.060731] kobject: 'notes'
(ffff880127941908): kobject_add_internal: parent: 'snd_pcm_oss', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.085102] kobject:
'snd_hda_intel' (ffffffffa0256350): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [    9.087778] kobject: 'holders'
(ffff880127941110): kobject_add_internal: parent: 'snd_hda_intel',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.087815] kobject:
'snd_hda_intel' (ffffffffa0256350): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.087825] kobject:
'snd_hda_intel' (ffffffffa0256350): fill_kobj_path: path =
'/module/snd_hda_intel'
Dec  6 11:42:22 debian-hell kernel: [    9.087874] kobject: 'notes'
(ffff88012f01ea18): kobject_add_internal: parent: 'snd_hda_intel',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.087929] kobject: 'HDA
Intel' (ffff8801275f36c0): kobject_add_internal: parent: 'drivers',
set: 'drivers'
Dec  6 11:42:22 debian-hell kernel: [    9.088024] HDA Intel
0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Dec  6 11:42:22 debian-hell kernel: [    9.088144] HDA Intel
0000:00:1b.0: setting latency timer to 64
Dec  6 11:42:22 debian-hell kernel: [    9.122623] hda_codec: Unknown
model for ALC882, trying auto-probe from BIOS...
Dec  6 11:42:22 debian-hell kernel: [    9.159000] kobject: 'sound'
(ffff880126036198): kobject_add_internal: parent: '0000:00:1b.0', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.159007] kobject: 'card0'
(ffff880127a1b958): kobject_add_internal: parent: 'sound', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159023] PM: Adding info for
No Bus:card0
Dec  6 11:42:22 debian-hell kernel: [    9.159025] kobject: 'card0'
(ffff880127a1b958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159035] kobject: 'card0'
(ffff880127a1b958): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0'
Dec  6 11:42:22 debian-hell kernel: [    9.159058] kobject: 'pcmC0D2c'
(ffff880127a1e870): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159085] PM: Adding info for
No Bus:pcmC0D2c
Dec  6 11:42:22 debian-hell kernel: [    9.159087] kobject: 'pcmC0D2c'
(ffff880127a1e870): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159099] kobject: 'pcmC0D2c'
(ffff880127a1e870): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D2c'
Dec  6 11:42:22 debian-hell kernel: [    9.159124] kobject: 'pcmC0D1p'
(ffff880127a1dfe0): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159147] PM: Adding info for
No Bus:pcmC0D1p
Dec  6 11:42:22 debian-hell kernel: [    9.159148] kobject: 'pcmC0D1p'
(ffff880127a1dfe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159160] kobject: 'pcmC0D1p'
(ffff880127a1dfe0): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D1p'
Dec  6 11:42:22 debian-hell kernel: [    9.159182] kobject: 'pcmC0D1c'
(ffff88012761c630): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159200] PM: Adding info for
No Bus:pcmC0D1c
Dec  6 11:42:22 debian-hell kernel: [    9.159202] kobject: 'pcmC0D1c'
(ffff88012761c630): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159214] kobject: 'pcmC0D1c'
(ffff88012761c630): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D1c'
Dec  6 11:42:22 debian-hell kernel: [    9.159237] kobject: 'adsp'
(ffff8801274f5308): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159261] PM: Adding info for
No Bus:adsp
Dec  6 11:42:22 debian-hell kernel: [    9.159263] kobject: 'adsp'
(ffff8801274f5308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159274] kobject: 'adsp'
(ffff8801274f5308): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/adsp'
Dec  6 11:42:22 debian-hell kernel: [    9.159302] kobject: 'pcmC0D0p'
(ffff880127755308): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159325] PM: Adding info for
No Bus:pcmC0D0p
Dec  6 11:42:22 debian-hell kernel: [    9.159327] kobject: 'pcmC0D0p'
(ffff880127755308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159339] kobject: 'pcmC0D0p'
(ffff880127755308): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0p'
Dec  6 11:42:22 debian-hell kernel: [    9.159368] kobject: 'pcmC0D0c'
(ffff8801275c85f8): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159413] PM: Adding info for
No Bus:pcmC0D0c
Dec  6 11:42:22 debian-hell kernel: [    9.159415] kobject: 'pcmC0D0c'
(ffff8801275c85f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159425] kobject: 'pcmC0D0c'
(ffff8801275c85f8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0c'
Dec  6 11:42:22 debian-hell kernel: [    9.159447] kobject: 'dsp'
(ffff8801275c8e88): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159475] PM: Adding info for
No Bus:dsp
Dec  6 11:42:22 debian-hell kernel: [    9.159477] kobject: 'dsp'
(ffff8801275c8e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159488] kobject: 'dsp'
(ffff8801275c8e88): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/dsp'
Dec  6 11:42:22 debian-hell kernel: [    9.159506] kobject: 'audio'
(ffff8801275c9718): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159524] PM: Adding info for
No Bus:audio
Dec  6 11:42:22 debian-hell kernel: [    9.159526] kobject: 'audio'
(ffff8801275c9718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159538] kobject: 'audio'
(ffff8801275c9718): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/audio'
Dec  6 11:42:22 debian-hell kernel: [    9.159575] kobject:
'controlC0' (ffff8801275c9fa8): kobject_add_internal: parent: 'card0',
set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159593] PM: Adding info for
No Bus:controlC0
Dec  6 11:42:22 debian-hell kernel: [    9.159595] kobject:
'controlC0' (ffff8801275c9fa8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159607] kobject:
'controlC0' (ffff8801275c9fa8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/controlC0'
Dec  6 11:42:22 debian-hell kernel: [    9.159636] kobject: 'mixer'
(ffff8801275ca838): kobject_add_internal: parent: 'card0', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.159658] PM: Adding info for
No Bus:mixer
Dec  6 11:42:22 debian-hell kernel: [    9.159660] kobject: 'mixer'
(ffff8801275ca838): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.159671] kobject: 'mixer'
(ffff8801275ca838): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1b.0/sound/card0/mixer'
Dec  6 11:42:22 debian-hell kernel: [    9.160273] HDA Intel
0000:02:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Dec  6 11:42:22 debian-hell kernel: [    9.160358] HDA Intel
0000:02:00.1: setting latency timer to 64
Dec  6 11:42:22 debian-hell kernel: [    9.208808] kobject: 'sound'
(ffff880126123660): kobject_add_internal: parent: '0000:02:00.1', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.208819] kobject: 'card1'
(ffff8801275c9b60): kobject_add_internal: parent: 'sound', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.208839] PM: Adding info for
No Bus:card1
Dec  6 11:42:22 debian-hell kernel: [    9.208841] kobject: 'card1'
(ffff8801275c9b60): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.208851] kobject: 'card1'
(ffff8801275c9b60): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:03.0/0000:02:00.1/sound/card1'
Dec  6 11:42:22 debian-hell kernel: [    9.208872] kobject: 'pcmC1D3p'
(ffff8801275c8a40): kobject_add_internal: parent: 'card1', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.208898] PM: Adding info for
No Bus:pcmC1D3p
Dec  6 11:42:22 debian-hell kernel: [    9.208900] kobject: 'pcmC1D3p'
(ffff8801275c8a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.208912] kobject: 'pcmC1D3p'
(ffff8801275c8a40): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:03.0/0000:02:00.1/sound/card1/pcmC1D3p'
Dec  6 11:42:22 debian-hell kernel: [    9.208940] kobject:
'controlC1' (ffff8801275cb958): kobject_add_internal: parent: 'card1',
set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.208963] PM: Adding info for
No Bus:controlC1
Dec  6 11:42:22 debian-hell kernel: [    9.208965] kobject:
'controlC1' (ffff8801275cb958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.208977] kobject:
'controlC1' (ffff8801275cb958): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:03.0/0000:02:00.1/sound/card1/controlC1'
Dec  6 11:42:22 debian-hell kernel: [    9.209006] kobject: 'mixer1'
(ffff8801275cc1e8): kobject_add_internal: parent: 'card1', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [    9.209025] PM: Adding info for
No Bus:mixer1
Dec  6 11:42:22 debian-hell kernel: [    9.209027] kobject: 'mixer1'
(ffff8801275cc1e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.209038] kobject: 'mixer1'
(ffff8801275cc1e8): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:03.0/0000:02:00.1/sound/card1/mixer1'
Dec  6 11:42:22 debian-hell kernel: [    9.209249] kobject: 'drivers'
(ffff880126123000): kobject_add_internal: parent: 'snd_hda_intel',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [    9.209260] kobject: 'HDA
Intel' (ffff8801275f36c0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [    9.209271] kobject: 'HDA
Intel' (ffff8801275f36c0): fill_kobj_path: path =
'/bus/pci/drivers/HDA Intel'
Dec  6 11:42:22 debian-hell kernel: [   10.047657] Adding 48829528k
swap on /dev/sda1.  Priority:-1 extents:1 across:48829528k
Dec  6 11:42:22 debian-hell kernel: [   10.359814] EXT3 FS on sda3,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   11.125137] kobject: 'loop'
(ffffffffa025ccd0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [   11.126145] kobject: 'holders'
(ffff880127078198): kobject_add_internal: parent: 'loop', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.126161] kobject: 'loop'
(ffffffffa025ccd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.126171] kobject: 'loop'
(ffffffffa025ccd0): fill_kobj_path: path = '/module/loop'
Dec  6 11:42:22 debian-hell kernel: [   11.126703] kobject: 'notes'
(ffff880127078770): kobject_add_internal: parent: 'loop', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.127048] kobject: 'loop0'
(ffff8801275ecca0): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.127088] PM: Adding info for
No Bus:loop0
Dec  6 11:42:22 debian-hell kernel: [   11.127090] kobject: 'loop0'
(ffff8801275ecca0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.127092] kobject: 'loop0'
(ffff8801275ecca0): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.127104] kobject: 'holders'
(ffff880124802000): kobject_add_internal: parent: 'loop0', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.127109] kobject: 'slaves'
(ffff880124802088): kobject_add_internal: parent: 'loop0', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.127113] kobject: 'loop0'
(ffff8801275ecca0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.127125] kobject: 'loop0'
(ffff8801275ecca0): fill_kobj_path: path =
'/devices/virtual/block/loop0'
Dec  6 11:42:22 debian-hell kernel: [   11.127147] kobject: '7:0'
(ffff8801275ce428): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.127701] PM: Adding info for
No Bus:7:0
Dec  6 11:42:22 debian-hell kernel: [   11.127703] kobject: '7:0'
(ffff8801275ce428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.127714] kobject: '7:0'
(ffff8801275ce428): fill_kobj_path: path = '/devices/virtual/bdi/7:0'
Dec  6 11:42:22 debian-hell kernel: [   11.128174] kobject: 'loop1'
(ffff8801270cd4e8): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.128210] PM: Adding info for
No Bus:loop1
Dec  6 11:42:22 debian-hell kernel: [   11.128212] kobject: 'loop1'
(ffff8801270cd4e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.128214] kobject: 'loop1'
(ffff8801270cd4e8): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.128226] kobject: 'holders'
(ffff8801248022a8): kobject_add_internal: parent: 'loop1', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.128231] kobject: 'slaves'
(ffff880124802330): kobject_add_internal: parent: 'loop1', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.128235] kobject: 'loop1'
(ffff8801270cd4e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.128246] kobject: 'loop1'
(ffff8801270cd4e8): fill_kobj_path: path =
'/devices/virtual/block/loop1'
Dec  6 11:42:22 debian-hell kernel: [   11.128267] kobject: '7:1'
(ffff8801275ce870): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.128730] PM: Adding info for
No Bus:7:1
Dec  6 11:42:22 debian-hell kernel: [   11.128734] kobject: '7:1'
(ffff8801275ce870): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.128763] kobject: '7:1'
(ffff8801275ce870): fill_kobj_path: path = '/devices/virtual/bdi/7:1'
Dec  6 11:42:22 debian-hell kernel: [   11.128800] kobject: 'loop2'
(ffff8801270ce578): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.128844] PM: Adding info for
No Bus:loop2
Dec  6 11:42:22 debian-hell kernel: [   11.128847] kobject: 'loop2'
(ffff8801270ce578): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.128850] kobject: 'loop2'
(ffff8801270ce578): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.128859] kobject: 'holders'
(ffff8801248024c8): kobject_add_internal: parent: 'loop2', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.128866] kobject: 'slaves'
(ffff880124802550): kobject_add_internal: parent: 'loop2', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.128871] kobject: 'loop2'
(ffff8801270ce578): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.128888] kobject: 'loop2'
(ffff8801270ce578): fill_kobj_path: path =
'/devices/virtual/block/loop2'
Dec  6 11:42:22 debian-hell kernel: [   11.128916] kobject: '7:2'
(ffff8801275cecb8): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.128961] PM: Adding info for
No Bus:7:2
Dec  6 11:42:22 debian-hell kernel: [   11.128964] kobject: '7:2'
(ffff8801275cecb8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.128984] kobject: '7:2'
(ffff8801275cecb8): fill_kobj_path: path = '/devices/virtual/bdi/7:2'
Dec  6 11:42:22 debian-hell kernel: [   11.129021] kobject: 'loop3'
(ffff8801270cedc0): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129065] PM: Adding info for
No Bus:loop3
Dec  6 11:42:22 debian-hell kernel: [   11.129068] kobject: 'loop3'
(ffff8801270cedc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129070] kobject: 'loop3'
(ffff8801270cedc0): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.129079] kobject: 'holders'
(ffff880124802660): kobject_add_internal: parent: 'loop3', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129086] kobject: 'slaves'
(ffff8801248026e8): kobject_add_internal: parent: 'loop3', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129092] kobject: 'loop3'
(ffff8801270cedc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129109] kobject: 'loop3'
(ffff8801270cedc0): fill_kobj_path: path =
'/devices/virtual/block/loop3'
Dec  6 11:42:22 debian-hell kernel: [   11.129136] kobject: '7:3'
(ffff8801275cf548): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129168] PM: Adding info for
No Bus:7:3
Dec  6 11:42:22 debian-hell kernel: [   11.129171] kobject: '7:3'
(ffff8801275cf548): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129186] kobject: '7:3'
(ffff8801275cf548): fill_kobj_path: path = '/devices/virtual/bdi/7:3'
Dec  6 11:42:22 debian-hell kernel: [   11.129223] kobject: 'loop4'
(ffff8801270e7608): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129281] PM: Adding info for
No Bus:loop4
Dec  6 11:42:22 debian-hell kernel: [   11.129285] kobject: 'loop4'
(ffff8801270e7608): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129287] kobject: 'loop4'
(ffff8801270e7608): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.129297] kobject: 'holders'
(ffff8801248027f8): kobject_add_internal: parent: 'loop4', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129304] kobject: 'slaves'
(ffff880124802880): kobject_add_internal: parent: 'loop4', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129310] kobject: 'loop4'
(ffff8801270e7608): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129328] kobject: 'loop4'
(ffff8801270e7608): fill_kobj_path: path =
'/devices/virtual/block/loop4'
Dec  6 11:42:22 debian-hell kernel: [   11.129358] kobject: '7:4'
(ffff880127a1e428): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129402] PM: Adding info for
No Bus:7:4
Dec  6 11:42:22 debian-hell kernel: [   11.129405] kobject: '7:4'
(ffff880127a1e428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129422] kobject: '7:4'
(ffff880127a1e428): fill_kobj_path: path = '/devices/virtual/bdi/7:4'
Dec  6 11:42:22 debian-hell kernel: [   11.129458] kobject: 'loop5'
(ffff8801270e6dc0): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129501] PM: Adding info for
No Bus:loop5
Dec  6 11:42:22 debian-hell kernel: [   11.129504] kobject: 'loop5'
(ffff8801270e6dc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129506] kobject: 'loop5'
(ffff8801270e6dc0): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.129515] kobject: 'holders'
(ffff880124802990): kobject_add_internal: parent: 'loop5', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129522] kobject: 'slaves'
(ffff880124802a18): kobject_add_internal: parent: 'loop5', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129528] kobject: 'loop5'
(ffff8801270e6dc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129544] kobject: 'loop5'
(ffff8801270e6dc0): fill_kobj_path: path =
'/devices/virtual/block/loop5'
Dec  6 11:42:22 debian-hell kernel: [   11.129572] kobject: '7:5'
(ffff88012761ca78): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129599] PM: Adding info for
No Bus:7:5
Dec  6 11:42:22 debian-hell kernel: [   11.129602] kobject: '7:5'
(ffff88012761ca78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129618] kobject: '7:5'
(ffff88012761ca78): fill_kobj_path: path = '/devices/virtual/bdi/7:5'
Dec  6 11:42:22 debian-hell kernel: [   11.129655] kobject: 'loop6'
(ffff8801270e4ca0): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129701] PM: Adding info for
No Bus:loop6
Dec  6 11:42:22 debian-hell kernel: [   11.129704] kobject: 'loop6'
(ffff8801270e4ca0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129707] kobject: 'loop6'
(ffff8801270e4ca0): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.129715] kobject: 'holders'
(ffff880124802b28): kobject_add_internal: parent: 'loop6', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129723] kobject: 'slaves'
(ffff880124802bb0): kobject_add_internal: parent: 'loop6', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129729] kobject: 'loop6'
(ffff8801270e4ca0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129747] kobject: 'loop6'
(ffff8801270e4ca0): fill_kobj_path: path =
'/devices/virtual/block/loop6'
Dec  6 11:42:22 debian-hell kernel: [   11.129776] kobject: '7:6'
(ffff880127757990): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129802] PM: Adding info for
No Bus:7:6
Dec  6 11:42:22 debian-hell kernel: [   11.129805] kobject: '7:6'
(ffff880127757990): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129823] kobject: '7:6'
(ffff880127757990): fill_kobj_path: path = '/devices/virtual/bdi/7:6'
Dec  6 11:42:22 debian-hell kernel: [   11.129878] kobject: 'loop7'
(ffff880127adedc0): kobject_add_internal: parent: 'block', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.129917] PM: Adding info for
No Bus:loop7
Dec  6 11:42:22 debian-hell kernel: [   11.129920] kobject: 'loop7'
(ffff880127adedc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129923] kobject: 'loop7'
(ffff880127adedc0): kobject_uevent_env: filter function caused the
event to drop!
Dec  6 11:42:22 debian-hell kernel: [   11.129932] kobject: 'holders'
(ffff880124802cc0): kobject_add_internal: parent: 'loop7', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129939] kobject: 'slaves'
(ffff880124802d48): kobject_add_internal: parent: 'loop7', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   11.129945] kobject: 'loop7'
(ffff880127adedc0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.129963] kobject: 'loop7'
(ffff880127adedc0): fill_kobj_path: path =
'/devices/virtual/block/loop7'
Dec  6 11:42:22 debian-hell kernel: [   11.130003] kobject: '7:7'
(ffff880124a081b0): kobject_add_internal: parent: 'bdi', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   11.130038] PM: Adding info for
No Bus:7:7
Dec  6 11:42:22 debian-hell kernel: [   11.130041] kobject: '7:7'
(ffff880124a081b0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   11.130060] kobject: '7:7'
(ffff880124a081b0): fill_kobj_path: path = '/devices/virtual/bdi/7:7'
Dec  6 11:42:22 debian-hell kernel: [   11.130095] loop: module loaded
Dec  6 11:42:22 debian-hell kernel: [   13.369394] kobject: 'fuse'
(ffffffffa026bed0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:22 debian-hell kernel: [   13.371100] kobject: 'holders'
(ffff880126958c38): kobject_add_internal: parent: 'fuse', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   13.371111] kobject: 'fuse'
(ffffffffa026bed0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   13.371123] kobject: 'fuse'
(ffffffffa026bed0): fill_kobj_path: path = '/module/fuse'
Dec  6 11:42:22 debian-hell kernel: [   13.371656] kobject: 'notes'
(ffff880126958cc0): kobject_add_internal: parent: 'fuse', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   13.371676] fuse init (API version 7.9)
Dec  6 11:42:22 debian-hell kernel: [   13.371757] kobject:
'fuse_inode' (ffff880125881120): kobject_add_internal: parent: 'slab',
set: 'slab'
Dec  6 11:42:22 debian-hell kernel: [   13.371801] kobject:
'fuse_inode' (ffff880125881120): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   13.371812] kobject:
'fuse_inode' (ffff880125881120): fill_kobj_path: path =
'/kernel/slab/fuse_inode'
Dec  6 11:42:22 debian-hell kernel: [   13.372287] kobject:
'fuse_request' (ffff880125882168): kobject_add_internal: parent:
'slab', set: 'slab'
Dec  6 11:42:22 debian-hell kernel: [   13.372362] kobject:
'fuse_request' (ffff880125882168): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   13.372380] kobject:
'fuse_request' (ffff880125882168): fill_kobj_path: path =
'/kernel/slab/fuse_request'
Dec  6 11:42:22 debian-hell kernel: [   13.372407] kobject: 'fuse'
(ffff880124a085f8): kobject_add_internal: parent: 'misc', set:
'devices'
Dec  6 11:42:22 debian-hell kernel: [   13.372448] PM: Adding info for
No Bus:fuse
Dec  6 11:42:22 debian-hell kernel: [   13.372451] kobject: 'fuse'
(ffff880124a085f8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   13.372468] kobject: 'fuse'
(ffff880124a085f8): fill_kobj_path: path =
'/devices/virtual/misc/fuse'
Dec  6 11:42:22 debian-hell kernel: [   13.372488] kobject: 'fuse'
(ffff880126d72dd0): kobject_add_internal: parent: 'fs', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   13.372497] kobject:
'connections' (ffff880126d724c8): kobject_add_internal: parent:
'fuse', set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   13.454095] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.454590] EXT3 FS on sda5,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.454676] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.482078] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.522817] EXT3 FS on sda6,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.522902] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.766912] kobject:
'8:2-fuseblk' (ffff880124a08a40): kobject_add_internal: parent: 'bdi',
set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   13.766940] PM: Adding info for
No Bus:8:2-fuseblk
Dec  6 11:42:22 debian-hell kernel: [   13.766943] kobject:
'8:2-fuseblk' (ffff880124a08a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   13.766953] kobject:
'8:2-fuseblk' (ffff880124a08a40): fill_kobj_path: path =
'/devices/virtual/bdi/8:2-fuseblk'
Dec  6 11:42:22 debian-hell kernel: [   13.811789] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.812057] EXT3 FS on sdb1,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.812143] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.865427] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.865688] EXT3 FS on sdb2,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.865773] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.890263] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.890522] EXT3 FS on sdb5,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.890608] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.911093] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.911353] EXT3 FS on sdb6,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.911438] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.932458] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.932716] EXT3 FS on sdb7,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.932801] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.954730] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.955221] EXT3 FS on sdb8,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.955306] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   13.977570] kjournald starting.
 Commit interval 5 seconds
Dec  6 11:42:22 debian-hell kernel: [   13.977823] EXT3 FS on sdb3,
internal journal
Dec  6 11:42:22 debian-hell kernel: [   13.977909] EXT3-fs: mounted
filesystem with ordered data mode.
Dec  6 11:42:22 debian-hell kernel: [   14.815460] kobject: 'vcs2'
(ffff880127673510): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.815493] PM: Adding info for
No Bus:vcs2
Dec  6 11:42:22 debian-hell kernel: [   14.815495] kobject: 'vcs2'
(ffff880127673510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.815507] kobject: 'vcs2'
(ffff880127673510): fill_kobj_path: path = '/devices/virtual/vc/vcs2'
Dec  6 11:42:22 debian-hell kernel: [   14.815530] kobject: 'vcsa2'
(ffff880127673958): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.815551] PM: Adding info for
No Bus:vcsa2
Dec  6 11:42:22 debian-hell kernel: [   14.815553] kobject: 'vcsa2'
(ffff880127673958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.815564] kobject: 'vcsa2'
(ffff880127673958): fill_kobj_path: path = '/devices/virtual/vc/vcsa2'
Dec  6 11:42:22 debian-hell kernel: [   14.826632] PM: Removing info
for No Bus:vcs2
Dec  6 11:42:22 debian-hell kernel: [   14.826655] kobject: 'vcs2'
(ffff880127673510): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.826665] kobject: 'vcs2'
(ffff880127673510): fill_kobj_path: path = '/devices/virtual/vc/vcs2'
Dec  6 11:42:22 debian-hell kernel: [   14.826682] kobject: 'vcs2'
(ffff880127673510): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.826683] kobject: 'vcs2'
(ffff880127673510): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.826686] kobject: 'vcs2': free name
Dec  6 11:42:22 debian-hell kernel: [   14.826688] PM: Removing info
for No Bus:vcsa2
Dec  6 11:42:22 debian-hell kernel: [   14.826707] kobject: 'vcsa2'
(ffff880127673958): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.826717] kobject: 'vcsa2'
(ffff880127673958): fill_kobj_path: path = '/devices/virtual/vc/vcsa2'
Dec  6 11:42:22 debian-hell kernel: [   14.826731] kobject: 'vcsa2'
(ffff880127673958): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.826732] kobject: 'vcsa2'
(ffff880127673958): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.826735] kobject: 'vcsa2': free name
Dec  6 11:42:22 debian-hell kernel: [   14.827859] kobject: 'vcs3'
(ffff880126e64a78): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.827885] PM: Adding info for
No Bus:vcs3
Dec  6 11:42:22 debian-hell kernel: [   14.827887] kobject: 'vcs3'
(ffff880126e64a78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.827897] kobject: 'vcs3'
(ffff880126e64a78): fill_kobj_path: path = '/devices/virtual/vc/vcs3'
Dec  6 11:42:22 debian-hell kernel: [   14.827915] kobject: 'vcsa3'
(ffff880126e641e8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.827944] PM: Adding info for
No Bus:vcsa3
Dec  6 11:42:22 debian-hell kernel: [   14.827946] kobject: 'vcsa3'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.827957] kobject: 'vcsa3'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcsa3'
Dec  6 11:42:22 debian-hell kernel: [   14.839170] PM: Removing info
for No Bus:vcs3
Dec  6 11:42:22 debian-hell kernel: [   14.839191] kobject: 'vcs3'
(ffff880126e64a78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.839202] kobject: 'vcs3'
(ffff880126e64a78): fill_kobj_path: path = '/devices/virtual/vc/vcs3'
Dec  6 11:42:22 debian-hell kernel: [   14.839225] kobject: 'vcs3'
(ffff880126e64a78): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.839226] kobject: 'vcs3'
(ffff880126e64a78): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.839229] kobject: 'vcs3': free name
Dec  6 11:42:22 debian-hell kernel: [   14.839231] PM: Removing info
for No Bus:vcsa3
Dec  6 11:42:22 debian-hell kernel: [   14.839249] kobject: 'vcsa3'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.839260] kobject: 'vcsa3'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcsa3'
Dec  6 11:42:22 debian-hell kernel: [   14.839274] kobject: 'vcsa3'
(ffff880126e641e8): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.839275] kobject: 'vcsa3'
(ffff880126e641e8): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.839278] kobject: 'vcsa3': free name
Dec  6 11:42:22 debian-hell kernel: [   14.840406] kobject: 'vcs4'
(ffff8801275b8e88): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.840428] PM: Adding info for
No Bus:vcs4
Dec  6 11:42:22 debian-hell kernel: [   14.840430] kobject: 'vcs4'
(ffff8801275b8e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.840440] kobject: 'vcs4'
(ffff8801275b8e88): fill_kobj_path: path = '/devices/virtual/vc/vcs4'
Dec  6 11:42:22 debian-hell kernel: [   14.840459] kobject: 'vcsa4'
(ffff8801275b8a40): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.840478] PM: Adding info for
No Bus:vcsa4
Dec  6 11:42:22 debian-hell kernel: [   14.840479] kobject: 'vcsa4'
(ffff8801275b8a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.840490] kobject: 'vcsa4'
(ffff8801275b8a40): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Dec  6 11:42:22 debian-hell kernel: [   14.851718] PM: Removing info
for No Bus:vcs4
Dec  6 11:42:22 debian-hell kernel: [   14.851740] kobject: 'vcs4'
(ffff8801275b8e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.851750] kobject: 'vcs4'
(ffff8801275b8e88): fill_kobj_path: path = '/devices/virtual/vc/vcs4'
Dec  6 11:42:22 debian-hell kernel: [   14.851768] kobject: 'vcs4'
(ffff8801275b8e88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.851770] kobject: 'vcs4'
(ffff8801275b8e88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.851773] kobject: 'vcs4': free name
Dec  6 11:42:22 debian-hell kernel: [   14.851775] PM: Removing info
for No Bus:vcsa4
Dec  6 11:42:22 debian-hell kernel: [   14.851793] kobject: 'vcsa4'
(ffff8801275b8a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.851804] kobject: 'vcsa4'
(ffff8801275b8a40): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Dec  6 11:42:22 debian-hell kernel: [   14.851819] kobject: 'vcsa4'
(ffff8801275b8a40): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.851820] kobject: 'vcsa4'
(ffff8801275b8a40): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.851823] kobject: 'vcsa4': free name
Dec  6 11:42:22 debian-hell kernel: [   14.852723] kobject: 'vcs5'
(ffff8801275b92d0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.852747] PM: Adding info for
No Bus:vcs5
Dec  6 11:42:22 debian-hell kernel: [   14.852749] kobject: 'vcs5'
(ffff8801275b92d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.852766] kobject: 'vcs5'
(ffff8801275b92d0): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Dec  6 11:42:22 debian-hell kernel: [   14.852786] kobject: 'vcsa5'
(ffff8801275b8a40): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.852804] PM: Adding info for
No Bus:vcsa5
Dec  6 11:42:22 debian-hell kernel: [   14.852806] kobject: 'vcsa5'
(ffff8801275b8a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.852817] kobject: 'vcsa5'
(ffff8801275b8a40): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Dec  6 11:42:22 debian-hell kernel: [   14.863668] PM: Removing info
for No Bus:vcs5
Dec  6 11:42:22 debian-hell kernel: [   14.863689] kobject: 'vcs5'
(ffff8801275b92d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.863699] kobject: 'vcs5'
(ffff8801275b92d0): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Dec  6 11:42:22 debian-hell kernel: [   14.863719] kobject: 'vcs5'
(ffff8801275b92d0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.863721] kobject: 'vcs5'
(ffff8801275b92d0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.863724] kobject: 'vcs5': free name
Dec  6 11:42:22 debian-hell kernel: [   14.863726] PM: Removing info
for No Bus:vcsa5
Dec  6 11:42:22 debian-hell kernel: [   14.863743] kobject: 'vcsa5'
(ffff8801275b8a40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.863754] kobject: 'vcsa5'
(ffff8801275b8a40): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Dec  6 11:42:22 debian-hell kernel: [   14.863767] kobject: 'vcsa5'
(ffff8801275b8a40): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.863768] kobject: 'vcsa5'
(ffff8801275b8a40): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.863771] kobject: 'vcsa5': free name
Dec  6 11:42:22 debian-hell kernel: [   14.867346] kobject: 'vcs2'
(ffff880126e64630): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.867369] PM: Adding info for
No Bus:vcs2
Dec  6 11:42:22 debian-hell kernel: [   14.867371] kobject: 'vcs2'
(ffff880126e64630): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.867381] kobject: 'vcs2'
(ffff880126e64630): fill_kobj_path: path = '/devices/virtual/vc/vcs2'
Dec  6 11:42:22 debian-hell kernel: [   14.867855] kobject: 'vcsa2'
(ffff880126e641e8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.867877] PM: Adding info for
No Bus:vcsa2
Dec  6 11:42:22 debian-hell kernel: [   14.867879] kobject: 'vcsa2'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.867890] kobject: 'vcsa2'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcsa2'
Dec  6 11:42:22 debian-hell kernel: [   14.879253] PM: Removing info
for No Bus:vcs2
Dec  6 11:42:22 debian-hell kernel: [   14.879276] kobject: 'vcs2'
(ffff880126e64630): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.879286] kobject: 'vcs2'
(ffff880126e64630): fill_kobj_path: path = '/devices/virtual/vc/vcs2'
Dec  6 11:42:22 debian-hell kernel: [   14.879303] kobject: 'vcs2'
(ffff880126e64630): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.879305] kobject: 'vcs2'
(ffff880126e64630): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.879307] kobject: 'vcs2': free name
Dec  6 11:42:22 debian-hell kernel: [   14.879310] PM: Removing info
for No Bus:vcsa2
Dec  6 11:42:22 debian-hell kernel: [   14.879328] kobject: 'vcsa2'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.879339] kobject: 'vcsa2'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcsa2'
Dec  6 11:42:22 debian-hell kernel: [   14.879354] kobject: 'vcsa2'
(ffff880126e641e8): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.879355] kobject: 'vcsa2'
(ffff880126e641e8): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.879358] kobject: 'vcsa2': free name
Dec  6 11:42:22 debian-hell kernel: [   14.880473] kobject: 'vcs3'
(ffff880127415fe0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.880498] PM: Adding info for
No Bus:vcs3
Dec  6 11:42:22 debian-hell kernel: [   14.880499] kobject: 'vcs3'
(ffff880127415fe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.880510] kobject: 'vcs3'
(ffff880127415fe0): fill_kobj_path: path = '/devices/virtual/vc/vcs3'
Dec  6 11:42:22 debian-hell kernel: [   14.880527] kobject: 'vcsa3'
(ffff880127416428): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.880545] PM: Adding info for
No Bus:vcsa3
Dec  6 11:42:22 debian-hell kernel: [   14.880547] kobject: 'vcsa3'
(ffff880127416428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.880558] kobject: 'vcsa3'
(ffff880127416428): fill_kobj_path: path = '/devices/virtual/vc/vcsa3'
Dec  6 11:42:22 debian-hell kernel: [   14.891453] PM: Removing info
for No Bus:vcs3
Dec  6 11:42:22 debian-hell kernel: [   14.891474] kobject: 'vcs3'
(ffff880127415fe0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.891484] kobject: 'vcs3'
(ffff880127415fe0): fill_kobj_path: path = '/devices/virtual/vc/vcs3'
Dec  6 11:42:22 debian-hell kernel: [   14.891964] kobject: 'vcs3'
(ffff880127415fe0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.891965] kobject: 'vcs3'
(ffff880127415fe0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.891968] kobject: 'vcs3': free name
Dec  6 11:42:22 debian-hell kernel: [   14.891971] PM: Removing info
for No Bus:vcsa3
Dec  6 11:42:22 debian-hell kernel: [   14.891991] kobject: 'vcsa3'
(ffff880127416428): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.892003] kobject: 'vcsa3'
(ffff880127416428): fill_kobj_path: path = '/devices/virtual/vc/vcsa3'
Dec  6 11:42:22 debian-hell kernel: [   14.892465] kobject: 'vcsa3'
(ffff880127416428): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.892467] kobject: 'vcsa3'
(ffff880127416428): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.892470] kobject: 'vcsa3': free name
Dec  6 11:42:22 debian-hell kernel: [   14.892511] kobject: 'vcs4'
(ffff880127415308): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.892541] PM: Adding info for
No Bus:vcs4
Dec  6 11:42:22 debian-hell kernel: [   14.892544] kobject: 'vcs4'
(ffff880127415308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.892560] kobject: 'vcs4'
(ffff880127415308): fill_kobj_path: path = '/devices/virtual/vc/vcs4'
Dec  6 11:42:22 debian-hell kernel: [   14.892589] kobject: 'vcsa4'
(ffff880127415b98): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.892610] PM: Adding info for
No Bus:vcsa4
Dec  6 11:42:22 debian-hell kernel: [   14.892612] kobject: 'vcsa4'
(ffff880127415b98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.892623] kobject: 'vcsa4'
(ffff880127415b98): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Dec  6 11:42:22 debian-hell kernel: [   14.903834] PM: Removing info
for No Bus:vcs4
Dec  6 11:42:22 debian-hell kernel: [   14.903854] kobject: 'vcs4'
(ffff880127415308): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.903864] kobject: 'vcs4'
(ffff880127415308): fill_kobj_path: path = '/devices/virtual/vc/vcs4'
Dec  6 11:42:22 debian-hell kernel: [   14.904324] kobject: 'vcs4'
(ffff880127415308): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.904326] kobject: 'vcs4'
(ffff880127415308): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.904329] kobject: 'vcs4': free name
Dec  6 11:42:22 debian-hell kernel: [   14.904331] PM: Removing info
for No Bus:vcsa4
Dec  6 11:42:22 debian-hell kernel: [   14.904351] kobject: 'vcsa4'
(ffff880127415b98): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.904361] kobject: 'vcsa4'
(ffff880127415b98): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Dec  6 11:42:22 debian-hell kernel: [   14.904801] kobject: 'vcsa4'
(ffff880127415b98): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.904803] kobject: 'vcsa4'
(ffff880127415b98): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.904806] kobject: 'vcsa4': free name
Dec  6 11:42:22 debian-hell kernel: [   14.905979] kobject: 'vcs5'
(ffff8801276741e8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.906000] PM: Adding info for
No Bus:vcs5
Dec  6 11:42:22 debian-hell kernel: [   14.906002] kobject: 'vcs5'
(ffff8801276741e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.906012] kobject: 'vcs5'
(ffff8801276741e8): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Dec  6 11:42:22 debian-hell kernel: [   14.906034] kobject: 'vcsa5'
(ffff8801276723f0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.906051] PM: Adding info for
No Bus:vcsa5
Dec  6 11:42:22 debian-hell kernel: [   14.906052] kobject: 'vcsa5'
(ffff8801276723f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.906063] kobject: 'vcsa5'
(ffff8801276723f0): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Dec  6 11:42:22 debian-hell kernel: [   14.916899] PM: Removing info
for No Bus:vcs5
Dec  6 11:42:22 debian-hell kernel: [   14.916922] kobject: 'vcs5'
(ffff8801276741e8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.916932] kobject: 'vcs5'
(ffff8801276741e8): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Dec  6 11:42:22 debian-hell kernel: [   14.916953] kobject: 'vcs5'
(ffff8801276741e8): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.916954] kobject: 'vcs5'
(ffff8801276741e8): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.916957] kobject: 'vcs5': free name
Dec  6 11:42:22 debian-hell kernel: [   14.916960] PM: Removing info
for No Bus:vcsa5
Dec  6 11:42:22 debian-hell kernel: [   14.916978] kobject: 'vcsa5'
(ffff8801276723f0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.916989] kobject: 'vcsa5'
(ffff8801276723f0): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Dec  6 11:42:22 debian-hell kernel: [   14.917003] kobject: 'vcsa5'
(ffff8801276723f0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.917004] kobject: 'vcsa5'
(ffff8801276723f0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.917007] kobject: 'vcsa5': free name
Dec  6 11:42:22 debian-hell kernel: [   14.918148] kobject: 'vcs6'
(ffff880126e64ec0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.918171] PM: Adding info for
No Bus:vcs6
Dec  6 11:42:22 debian-hell kernel: [   14.918173] kobject: 'vcs6'
(ffff880126e64ec0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.918183] kobject: 'vcs6'
(ffff880126e64ec0): fill_kobj_path: path = '/devices/virtual/vc/vcs6'
Dec  6 11:42:22 debian-hell kernel: [   14.918200] kobject: 'vcsa6'
(ffff880126e64a78): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   14.918217] PM: Adding info for
No Bus:vcsa6
Dec  6 11:42:22 debian-hell kernel: [   14.918219] kobject: 'vcsa6'
(ffff880126e64a78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.918229] kobject: 'vcsa6'
(ffff880126e64a78): fill_kobj_path: path = '/devices/virtual/vc/vcsa6'
Dec  6 11:42:22 debian-hell kernel: [   14.929420] PM: Removing info
for No Bus:vcs6
Dec  6 11:42:22 debian-hell kernel: [   14.929442] kobject: 'vcs6'
(ffff880126e64ec0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.929452] kobject: 'vcs6'
(ffff880126e64ec0): fill_kobj_path: path = '/devices/virtual/vc/vcs6'
Dec  6 11:42:22 debian-hell kernel: [   14.929910] kobject: 'vcs6'
(ffff880126e64ec0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.929912] kobject: 'vcs6'
(ffff880126e64ec0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.929915] kobject: 'vcs6': free name
Dec  6 11:42:22 debian-hell kernel: [   14.929918] PM: Removing info
for No Bus:vcsa6
Dec  6 11:42:22 debian-hell kernel: [   14.929940] kobject: 'vcsa6'
(ffff880126e64a78): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   14.929950] kobject: 'vcsa6'
(ffff880126e64a78): fill_kobj_path: path = '/devices/virtual/vc/vcsa6'
Dec  6 11:42:22 debian-hell kernel: [   14.930392] kobject: 'vcsa6'
(ffff880126e64a78): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   14.930393] kobject: 'vcsa6'
(ffff880126e64a78): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   14.930396] kobject: 'vcsa6': free name
Dec  6 11:42:22 debian-hell kernel: [   15.136377] r8169: eth1: link up
Dec  6 11:42:22 debian-hell kernel: [   15.338011] PM: Removing info
for No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.338047] kobject: 'vcs1'
(ffff880126e630c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.338058] kobject: 'vcs1'
(ffff880126e630c8): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.338557] kobject: 'vcs1'
(ffff880126e630c8): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.338559] kobject: 'vcs1'
(ffff880126e630c8): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.338563] kobject: 'vcs1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.338565] PM: Removing info
for No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.338592] kobject: 'vcsa1'
(ffff880126e63da0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.338603] kobject: 'vcsa1'
(ffff880126e63da0): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.339047] kobject: 'vcsa1'
(ffff880126e63da0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.339049] kobject: 'vcsa1'
(ffff880126e63da0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.339052] kobject: 'vcsa1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.355495] kobject: 'vcs1'
(ffff880124a092d0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.355523] PM: Adding info for
No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.355525] kobject: 'vcs1'
(ffff880124a092d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355536] kobject: 'vcs1'
(ffff880124a092d0): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.355558] kobject: 'vcsa1'
(ffff880124a08e88): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.355574] PM: Adding info for
No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.355576] kobject: 'vcsa1'
(ffff880124a08e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355587] kobject: 'vcsa1'
(ffff880124a08e88): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.355649] PM: Removing info
for No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.355665] kobject: 'vcs1'
(ffff880124a092d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355675] kobject: 'vcs1'
(ffff880124a092d0): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.355689] kobject: 'vcs1'
(ffff880124a092d0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.355690] kobject: 'vcs1'
(ffff880124a092d0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.355693] kobject: 'vcs1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.355695] PM: Removing info
for No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.355710] kobject: 'vcsa1'
(ffff880124a08e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355719] kobject: 'vcsa1'
(ffff880124a08e88): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.355733] kobject: 'vcsa1'
(ffff880124a08e88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.355734] kobject: 'vcsa1'
(ffff880124a08e88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.355737] kobject: 'vcsa1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.355774] kobject: 'vcs1'
(ffff880124a09718): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.355791] PM: Adding info for
No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.355793] kobject: 'vcs1'
(ffff880124a09718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355803] kobject: 'vcs1'
(ffff880124a09718): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.355819] kobject: 'vcsa1'
(ffff880124a08e88): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.355835] PM: Adding info for
No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.355836] kobject: 'vcsa1'
(ffff880124a08e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355847] kobject: 'vcsa1'
(ffff880124a08e88): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.355910] PM: Removing info
for No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.355925] kobject: 'vcs1'
(ffff880124a09718): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355936] kobject: 'vcs1'
(ffff880124a09718): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.355949] kobject: 'vcs1'
(ffff880124a09718): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.355951] kobject: 'vcs1'
(ffff880124a09718): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.355954] kobject: 'vcs1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.355956] PM: Removing info
for No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.355971] kobject: 'vcsa1'
(ffff880124a08e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.355981] kobject: 'vcsa1'
(ffff880124a08e88): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.355995] kobject: 'vcsa1'
(ffff880124a08e88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.355996] kobject: 'vcsa1'
(ffff880124a08e88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.355999] kobject: 'vcsa1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.356035] kobject: 'vcs1'
(ffff880124a092d0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.356052] PM: Adding info for
No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.356053] kobject: 'vcs1'
(ffff880124a092d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.356064] kobject: 'vcs1'
(ffff880124a092d0): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.356079] kobject: 'vcsa1'
(ffff880124a08e88): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.356095] PM: Adding info for
No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.356096] kobject: 'vcsa1'
(ffff880124a08e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.356107] kobject: 'vcsa1'
(ffff880124a08e88): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.356204] PM: Removing info
for No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.356219] kobject: 'vcs1'
(ffff880124a092d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.356230] kobject: 'vcs1'
(ffff880124a092d0): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.356245] kobject: 'vcs1'
(ffff880124a092d0): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.356246] kobject: 'vcs1'
(ffff880124a092d0): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.356249] kobject: 'vcs1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.356251] PM: Removing info
for No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.356266] kobject: 'vcsa1'
(ffff880124a08e88): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.356277] kobject: 'vcsa1'
(ffff880124a08e88): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.356291] kobject: 'vcsa1'
(ffff880124a08e88): kobject_cleanup
Dec  6 11:42:22 debian-hell kernel: [   15.356292] kobject: 'vcsa1'
(ffff880124a08e88): calling ktype release
Dec  6 11:42:22 debian-hell kernel: [   15.356295] kobject: 'vcsa1': free name
Dec  6 11:42:22 debian-hell kernel: [   15.356612] kobject: 'vcs1'
(ffff880126e63da0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.356635] PM: Adding info for
No Bus:vcs1
Dec  6 11:42:22 debian-hell kernel: [   15.356637] kobject: 'vcs1'
(ffff880126e63da0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.356647] kobject: 'vcs1'
(ffff880126e63da0): fill_kobj_path: path = '/devices/virtual/vc/vcs1'
Dec  6 11:42:22 debian-hell kernel: [   15.356670] kobject: 'vcsa1'
(ffff880126e630c8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:22 debian-hell kernel: [   15.356687] PM: Adding info for
No Bus:vcsa1
Dec  6 11:42:22 debian-hell kernel: [   15.356689] kobject: 'vcsa1'
(ffff880126e630c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.356700] kobject: 'vcsa1'
(ffff880126e630c8): fill_kobj_path: path = '/devices/virtual/vc/vcsa1'
Dec  6 11:42:22 debian-hell kernel: [   15.455439] kobject:
'cpufreq_stats' (ffffffffa02701d0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [   15.456203] kobject: 'holders'
(ffff880124066aa0): kobject_add_internal: parent: 'cpufreq_stats',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.456215] kobject:
'cpufreq_stats' (ffffffffa02701d0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.456225] kobject:
'cpufreq_stats' (ffffffffa02701d0): fill_kobj_path: path =
'/module/cpufreq_stats'
Dec  6 11:42:22 debian-hell kernel: [   15.456741] kobject: 'notes'
(ffff880124066990): kobject_add_internal: parent: 'cpufreq_stats',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.462606] kobject:
'cpufreq_userspace' (ffffffffa0273ed0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [   15.463271] kobject: 'holders'
(ffff880124066110): kobject_add_internal: parent: 'cpufreq_userspace',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.463284] kobject:
'cpufreq_userspace' (ffffffffa0273ed0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.463294] kobject:
'cpufreq_userspace' (ffffffffa0273ed0): fill_kobj_path: path =
'/module/cpufreq_userspace'
Dec  6 11:42:22 debian-hell kernel: [   15.463343] kobject: 'notes'
(ffff8801240664c8): kobject_add_internal: parent: 'cpufreq_userspace',
set: '<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.514679] kobject:
'acpi_cpufreq' (ffffffffa0278dd0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:22 debian-hell kernel: [   15.515922] kobject: 'holders'
(ffff8801240663b8): kobject_add_internal: parent: 'acpi_cpufreq', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.515938] kobject:
'acpi_cpufreq' (ffffffffa0278dd0): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.515948] kobject:
'acpi_cpufreq' (ffffffffa0278dd0): fill_kobj_path: path =
'/module/acpi_cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.516475] kobject: 'notes'
(ffff8801240662a8): kobject_add_internal: parent: 'acpi_cpufreq', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.518132] kobject: 'cpufreq'
(ffff880127973080): kobject_add_internal: parent: 'cpu0', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.518177] kobject: 'cpufreq'
(ffff880127973080): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.518188] kobject: 'cpufreq'
(ffff880127973080): fill_kobj_path: path =
'/devices/system/cpu/cpu0/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.518895] kobject: 'cpufreq'
(ffff8801266e52d8): kobject_add_internal: parent: 'cpu1', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.518946] kobject: 'cpufreq'
(ffff8801266e52d8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.518957] kobject: 'cpufreq'
(ffff8801266e52d8): fill_kobj_path: path =
'/devices/system/cpu/cpu1/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.519673] kobject: 'cpufreq'
(ffff880127900770): kobject_add_internal: parent: 'cpu2', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.519743] kobject: 'cpufreq'
(ffff880127900770): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.519762] kobject: 'cpufreq'
(ffff880127900770): fill_kobj_path: path =
'/devices/system/cpu/cpu2/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.520559] kobject: 'cpufreq'
(ffff880127929e40): kobject_add_internal: parent: 'cpu3', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.520608] kobject: 'cpufreq'
(ffff880127929e40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.520618] kobject: 'cpufreq'
(ffff880127929e40): fill_kobj_path: path =
'/devices/system/cpu/cpu3/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.521329] kobject: 'cpufreq'
(ffff8801279732c8): kobject_add_internal: parent: 'cpu4', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.521374] kobject: 'cpufreq'
(ffff8801279732c8): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.521386] kobject: 'cpufreq'
(ffff8801279732c8): fill_kobj_path: path =
'/devices/system/cpu/cpu4/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.522105] kobject: 'cpufreq'
(ffff88012922a088): kobject_add_internal: parent: 'cpu5', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.522154] kobject: 'cpufreq'
(ffff88012922a088): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.522165] kobject: 'cpufreq'
(ffff88012922a088): fill_kobj_path: path =
'/devices/system/cpu/cpu5/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.522868] kobject: 'cpufreq'
(ffff880127021e40): kobject_add_internal: parent: 'cpu6', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.522918] kobject: 'cpufreq'
(ffff880127021e40): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.522930] kobject: 'cpufreq'
(ffff880127021e40): fill_kobj_path: path =
'/devices/system/cpu/cpu6/cpufreq'
Dec  6 11:42:22 debian-hell kernel: [   15.523642] kobject: 'cpufreq'
(ffff8801279c3080): kobject_add_internal: parent: 'cpu7', set:
'<NULL>'
Dec  6 11:42:22 debian-hell kernel: [   15.523692] kobject: 'cpufreq'
(ffff8801279c3080): kobject_uevent_env
Dec  6 11:42:22 debian-hell kernel: [   15.523704] kobject: 'cpufreq'
(ffff8801279c3080): fill_kobj_path: path =
'/devices/system/cpu/cpu7/cpufreq'
Dec  6 11:42:23 debian-hell kernel: [   16.432286] kobject: '105'
(ffff880126892060): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:42:23 debian-hell kernel: [   16.432310] kobject: '105'
(ffff880126892060): kobject_uevent_env
Dec  6 11:42:23 debian-hell kernel: [   16.432331] kobject: '105'
(ffff880126892060): fill_kobj_path: path = '/kernel/uids/105'
Dec  6 11:42:24 debian-hell kernel: [   17.611610] kobject: 'kvm'
(ffffffffa029e4d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 11:42:24 debian-hell kernel: [   17.621786] kobject: 'holders'
(ffff880124aaf7f8): kobject_add_internal: parent: 'kvm', set: '<NULL>'
Dec  6 11:42:24 debian-hell kernel: [   17.621814] kobject: 'kvm'
(ffffffffa029e4d0): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.621837] kobject: 'kvm'
(ffffffffa029e4d0): fill_kobj_path: path = '/module/kvm'
Dec  6 11:42:24 debian-hell kernel: [   17.621979] kobject: 'notes'
(ffff880124aafbb0): kobject_add_internal: parent: 'kvm', set: '<NULL>'
Dec  6 11:42:24 debian-hell kernel: [   17.734854] kobject:
'kvm_intel' (ffffffffa02aa5d0): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:24 debian-hell kernel: [   17.739591] kobject: 'holders'
(ffff880124066d48): kobject_add_internal: parent: 'kvm_intel', set:
'<NULL>'
Dec  6 11:42:24 debian-hell kernel: [   17.739612] kobject:
'kvm_intel' (ffffffffa02aa5d0): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.739630] kobject:
'kvm_intel' (ffffffffa02aa5d0): fill_kobj_path: path =
'/module/kvm_intel'
Dec  6 11:42:24 debian-hell kernel: [   17.740670] kobject: 'notes'
(ffff880124066b28): kobject_add_internal: parent: 'kvm_intel', set:
'<NULL>'
Dec  6 11:42:24 debian-hell kernel: [   17.741045] kobject:
'kvm_pte_chain' (ffff88012452a168): kobject_add_internal: parent:
'slab', set: 'slab'
Dec  6 11:42:24 debian-hell kernel: [   17.741149] kobject:
'kvm_pte_chain' (ffff88012452a168): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.741183] kobject:
'kvm_pte_chain' (ffff88012452a168): fill_kobj_path: path =
'/kernel/slab/kvm_pte_chain'
Dec  6 11:42:24 debian-hell kernel: [   17.742208] kobject:
'kvm_rmap_desc' (ffff88012452b1b0): kobject_add_internal: parent:
'slab', set: 'slab'
Dec  6 11:42:24 debian-hell kernel: [   17.742312] kobject:
'kvm_rmap_desc' (ffff88012452b1b0): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.742343] kobject:
'kvm_rmap_desc' (ffff88012452b1b0): fill_kobj_path: path =
'/kernel/slab/kvm_rmap_desc'
Dec  6 11:42:24 debian-hell kernel: [   17.743365] kobject:
'kvm_mmu_page_header' (ffff88012452c1f8): kobject_add_internal:
parent: 'slab', set: 'slab'
Dec  6 11:42:24 debian-hell kernel: [   17.743470] kobject:
'kvm_mmu_page_header' (ffff88012452c1f8): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.743505] kobject:
'kvm_mmu_page_header' (ffff88012452c1f8): fill_kobj_path: path =
'/kernel/slab/kvm_mmu_page_header'
Dec  6 11:42:24 debian-hell kernel: [   17.744555] kobject: 'kvm'
(ffffffffa029d898): kobject_add_internal: parent: 'system', set:
'system'
Dec  6 11:42:24 debian-hell kernel: [   17.744575] kobject: 'kvm'
(ffffffffa029d898): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.744594] kobject: 'kvm'
(ffffffffa029d898): fill_kobj_path: path = '/devices/system/kvm'
Dec  6 11:42:24 debian-hell kernel: [   17.744624] kobject: 'kvm0'
(ffffffffa029d7e0): kobject_add_internal: parent: 'kvm', set: 'kvm'
Dec  6 11:42:24 debian-hell kernel: [   17.745671] kobject: 'kvm0'
(ffffffffa029d7e0): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.745701] kobject: 'kvm0'
(ffffffffa029d7e0): fill_kobj_path: path = '/devices/system/kvm/kvm0'
Dec  6 11:42:24 debian-hell kernel: [   17.747150] kobject: 'kvm_vcpu'
(ffff88012452d240): kobject_add_internal: parent: 'slab', set: 'slab'
Dec  6 11:42:24 debian-hell kernel: [   17.747250] kobject: 'kvm_vcpu'
(ffff88012452d240): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.747281] kobject: 'kvm_vcpu'
(ffff88012452d240): fill_kobj_path: path = '/kernel/slab/kvm_vcpu'
Dec  6 11:42:24 debian-hell kernel: [   17.748621] kobject: 'kvm'
(ffff880124a09b60): kobject_add_internal: parent: 'misc', set:
'devices'
Dec  6 11:42:24 debian-hell kernel: [   17.748679] PM: Adding info for
No Bus:kvm
Dec  6 11:42:24 debian-hell kernel: [   17.748682] kobject: 'kvm'
(ffff880124a09b60): kobject_uevent_env
Dec  6 11:42:24 debian-hell kernel: [   17.748703] kobject: 'kvm'
(ffff880124a09b60): fill_kobj_path: path = '/devices/virtual/misc/kvm'
Dec  6 11:42:25 debian-hell kernel: [   18.861532] kobject: '108'
(ffff88012416c060): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:42:25 debian-hell kernel: [   18.861549] kobject: '108'
(ffff88012416c060): kobject_uevent_env
Dec  6 11:42:25 debian-hell kernel: [   18.861561] kobject: '108'
(ffff88012416c060): fill_kobj_path: path = '/kernel/uids/108'
Dec  6 11:42:27 debian-hell kernel: [   20.538108] kobject: 'vcs7'
(ffff880126e641e8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:27 debian-hell kernel: [   20.538150] PM: Adding info for
No Bus:vcs7
Dec  6 11:42:27 debian-hell kernel: [   20.538153] kobject: 'vcs7'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:27 debian-hell kernel: [   20.538167] kobject: 'vcs7'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcs7'
Dec  6 11:42:27 debian-hell kernel: [   20.538207] kobject: 'vcsa7'
(ffff880126e65308): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:27 debian-hell kernel: [   20.538241] PM: Adding info for
No Bus:vcsa7
Dec  6 11:42:27 debian-hell kernel: [   20.538244] kobject: 'vcsa7'
(ffff880126e65308): kobject_uevent_env
Dec  6 11:42:27 debian-hell kernel: [   20.538258] kobject: 'vcsa7'
(ffff880126e65308): fill_kobj_path: path = '/devices/virtual/vc/vcsa7'
Dec  6 11:42:27 debian-hell kernel: [   20.720242] PM: Removing info
for No Bus:vcs7
Dec  6 11:42:27 debian-hell kernel: [   20.720287] kobject: 'vcs7'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:27 debian-hell kernel: [   20.720299] kobject: 'vcs7'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcs7'
Dec  6 11:42:27 debian-hell kernel: [   20.720840] kobject: 'vcs7'
(ffff880126e641e8): kobject_cleanup
Dec  6 11:42:27 debian-hell kernel: [   20.720842] kobject: 'vcs7'
(ffff880126e641e8): calling ktype release
Dec  6 11:42:27 debian-hell kernel: [   20.720845] kobject: 'vcs7': free name
Dec  6 11:42:27 debian-hell kernel: [   20.720848] PM: Removing info
for No Bus:vcsa7
Dec  6 11:42:27 debian-hell kernel: [   20.720877] kobject: 'vcsa7'
(ffff880126e65308): kobject_uevent_env
Dec  6 11:42:27 debian-hell kernel: [   20.720887] kobject: 'vcsa7'
(ffff880126e65308): fill_kobj_path: path = '/devices/virtual/vc/vcsa7'
Dec  6 11:42:27 debian-hell kernel: [   20.721346] kobject: 'vcsa7'
(ffff880126e65308): kobject_cleanup
Dec  6 11:42:27 debian-hell kernel: [   20.721348] kobject: 'vcsa7'
(ffff880126e65308): calling ktype release
Dec  6 11:42:27 debian-hell kernel: [   20.721351] kobject: 'vcsa7': free name
Dec  6 11:42:27 debian-hell kernel: [   20.903396] kobject: 'vcs7'
(ffff880127099b60): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:27 debian-hell kernel: [   20.903437] PM: Adding info for
No Bus:vcs7
Dec  6 11:42:27 debian-hell kernel: [   20.903440] kobject: 'vcs7'
(ffff880127099b60): kobject_uevent_env
Dec  6 11:42:27 debian-hell kernel: [   20.903450] kobject: 'vcs7'
(ffff880127099b60): fill_kobj_path: path = '/devices/virtual/vc/vcs7'
Dec  6 11:42:27 debian-hell kernel: [   20.903473] kobject: 'vcsa7'
(ffff880127099718): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:27 debian-hell kernel: [   20.903491] PM: Adding info for
No Bus:vcsa7
Dec  6 11:42:27 debian-hell kernel: [   20.903493] kobject: 'vcsa7'
(ffff880127099718): kobject_uevent_env
Dec  6 11:42:27 debian-hell kernel: [   20.903504] kobject: 'vcsa7'
(ffff880127099718): fill_kobj_path: path = '/devices/virtual/vc/vcsa7'
Dec  6 11:42:28 debian-hell kernel: [   21.464460] kobject:
'binfmt_misc' (ffffffffa02b1450): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 11:42:28 debian-hell kernel: [   21.465366] kobject: 'holders'
(ffff8801240036e8): kobject_add_internal: parent: 'binfmt_misc', set:
'<NULL>'
Dec  6 11:42:28 debian-hell kernel: [   21.465381] kobject:
'binfmt_misc' (ffffffffa02b1450): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.465392] kobject:
'binfmt_misc' (ffffffffa02b1450): fill_kobj_path: path =
'/module/binfmt_misc'
Dec  6 11:42:28 debian-hell kernel: [   21.465450] kobject: 'notes'
(ffff880124003660): kobject_add_internal: parent: 'binfmt_misc', set:
'<NULL>'
Dec  6 11:42:28 debian-hell kernel: [   21.593585] kobject: 'vcs2'
(ffff880126d40a40): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.593634] PM: Adding info for
No Bus:vcs2
Dec  6 11:42:28 debian-hell kernel: [   21.593637] kobject: 'vcs2'
(ffff880126d40a40): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.593651] kobject: 'vcs2'
(ffff880126d40a40): fill_kobj_path: path = '/devices/virtual/vc/vcs2'
Dec  6 11:42:28 debian-hell kernel: [   21.593680] kobject: 'vcsa2'
(ffff880126d405f8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.593705] PM: Adding info for
No Bus:vcsa2
Dec  6 11:42:28 debian-hell kernel: [   21.593707] kobject: 'vcsa2'
(ffff880126d405f8): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.593720] kobject: 'vcsa2'
(ffff880126d405f8): fill_kobj_path: path = '/devices/virtual/vc/vcsa2'
Dec  6 11:42:28 debian-hell kernel: [   21.593780] kobject: 'vcs3'
(ffff880126e641e8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.593809] PM: Adding info for
No Bus:vcs3
Dec  6 11:42:28 debian-hell kernel: [   21.593812] kobject: 'vcs3'
(ffff880126e641e8): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.593825] kobject: 'vcs3'
(ffff880126e641e8): fill_kobj_path: path = '/devices/virtual/vc/vcs3'
Dec  6 11:42:28 debian-hell kernel: [   21.593849] kobject: 'vcsa3'
(ffff880126e65308): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.593875] PM: Adding info for
No Bus:vcsa3
Dec  6 11:42:28 debian-hell kernel: [   21.593877] kobject: 'vcsa3'
(ffff880126e65308): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.593891] kobject: 'vcsa3'
(ffff880126e65308): fill_kobj_path: path = '/devices/virtual/vc/vcsa3'
Dec  6 11:42:28 debian-hell kernel: [   21.595255] kobject: 'vcs4'
(ffff8801270b7990): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.595286] PM: Adding info for
No Bus:vcs4
Dec  6 11:42:28 debian-hell kernel: [   21.595289] kobject: 'vcs4'
(ffff8801270b7990): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.595302] kobject: 'vcs4'
(ffff8801270b7990): fill_kobj_path: path = '/devices/virtual/vc/vcs4'
Dec  6 11:42:28 debian-hell kernel: [   21.595324] kobject: 'vcsa4'
(ffff8801270b6870): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.595349] PM: Adding info for
No Bus:vcsa4
Dec  6 11:42:28 debian-hell kernel: [   21.595351] kobject: 'vcsa4'
(ffff8801270b6870): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.595366] kobject: 'vcsa4'
(ffff8801270b6870): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Dec  6 11:42:28 debian-hell kernel: [   21.595638] kobject: 'vcs5'
(ffff8801275b8a40): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.595666] PM: Adding info for
No Bus:vcs5
Dec  6 11:42:28 debian-hell kernel: [   21.595668] kobject: 'vcs5'
(ffff8801275b8a40): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.595678] kobject: 'vcs5'
(ffff8801275b8a40): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Dec  6 11:42:28 debian-hell kernel: [   21.595694] kobject: 'vcsa5'
(ffff8801275b92d0): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.595712] PM: Adding info for
No Bus:vcsa5
Dec  6 11:42:28 debian-hell kernel: [   21.595713] kobject: 'vcsa5'
(ffff8801275b92d0): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.595724] kobject: 'vcsa5'
(ffff8801275b92d0): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Dec  6 11:42:28 debian-hell kernel: [   21.596592] kobject: 'vcs6'
(ffff8801275b85f8): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.596639] PM: Adding info for
No Bus:vcs6
Dec  6 11:42:28 debian-hell kernel: [   21.596641] kobject: 'vcs6'
(ffff8801275b85f8): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.596651] kobject: 'vcs6'
(ffff8801275b85f8): fill_kobj_path: path = '/devices/virtual/vc/vcs6'
Dec  6 11:42:28 debian-hell kernel: [   21.596667] kobject: 'vcsa6'
(ffff8801275b9718): kobject_add_internal: parent: 'vc', set: 'devices'
Dec  6 11:42:28 debian-hell kernel: [   21.596693] PM: Adding info for
No Bus:vcsa6
Dec  6 11:42:28 debian-hell kernel: [   21.596695] kobject: 'vcsa6'
(ffff8801275b9718): kobject_uevent_env
Dec  6 11:42:28 debian-hell kernel: [   21.596705] kobject: 'vcsa6'
(ffff8801275b9718): fill_kobj_path: path = '/devices/virtual/vc/vcsa6'
Dec  6 11:42:28 debian-hell kernel: [   21.663282] mtrr: type mismatch
for d0000000,1000000 old: write-back new: write-combining
Dec  6 11:42:30 debian-hell kernel: [   23.616288] kobject: '107'
(ffff88011cdb2060): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:42:30 debian-hell kernel: [   23.616337] kobject: '107'
(ffff88011cdb2060): kobject_uevent_env
Dec  6 11:42:30 debian-hell kernel: [   23.616349] kobject: '107'
(ffff88011cdb2060): fill_kobj_path: path = '/kernel/uids/107'
Dec  6 11:42:47 debian-hell kernel: [   40.827641] kobject: '1000'
(ffff8801268921a0): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:42:47 debian-hell kernel: [   40.827672] kobject: '1000'
(ffff8801268921a0): kobject_uevent_env
Dec  6 11:42:47 debian-hell kernel: [   40.827691] kobject: '1000'
(ffff8801268921a0): fill_kobj_path: path = '/kernel/uids/1000'
Dec  6 11:42:48 debian-hell kernel: [   41.056969] kobject: '107'
(ffff88011cdb2060): kobject_uevent_env
Dec  6 11:42:48 debian-hell kernel: [   41.057005] kobject: '107'
(ffff88011cdb2060): fill_kobj_path: path = '/kernel/uids/107'
Dec  6 11:42:48 debian-hell kernel: [   41.057051] kobject: '107'
(ffff88011cdb2060): kobject_cleanup
Dec  6 11:42:48 debian-hell kernel: [   41.057055] kobject: '107'
(ffff88011cdb2060): calling ktype release
Dec  6 11:42:48 debian-hell kernel: [   41.057057] kobject: '107': free name
Dec  6 11:42:54 debian-hell kernel: [   47.476937] warning:
`pulseaudio' uses 32-bit capabilities (legacy support in use)
Dec  6 11:47:08 debian-hell kernel: [  301.732037] Machine check events logged
Dec  6 11:49:29 debian-hell kernel: [  442.561605] kobject: '6'
(ffff88012416c1a0): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:49:29 debian-hell kernel: [  442.561625] kobject: '6'
(ffff88012416c1a0): kobject_uevent_env
Dec  6 11:49:29 debian-hell kernel: [  442.561637] kobject: '6'
(ffff88012416c1a0): fill_kobj_path: path = '/kernel/uids/6'
Dec  6 11:49:30 debian-hell kernel: [  443.748884] kobject: '6'
(ffff88012416c1a0): kobject_uevent_env
Dec  6 11:49:30 debian-hell kernel: [  443.748918] kobject: '6'
(ffff88012416c1a0): fill_kobj_path: path = '/kernel/uids/6'
Dec  6 11:49:30 debian-hell kernel: [  443.748967] kobject: '6'
(ffff88012416c1a0): kobject_cleanup
Dec  6 11:49:30 debian-hell kernel: [  443.748970] kobject: '6'
(ffff88012416c1a0): calling ktype release
Dec  6 11:49:30 debian-hell kernel: [  443.748973] kobject: '6': free name
Dec  6 11:55:36 debian-hell kernel: [  809.168761] kobject: '6'
(ffff88012416c1a0): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 11:55:36 debian-hell kernel: [  809.168790] kobject: '6'
(ffff88012416c1a0): kobject_uevent_env
Dec  6 11:55:36 debian-hell kernel: [  809.168810] kobject: '6'
(ffff88012416c1a0): fill_kobj_path: path = '/kernel/uids/6'
Dec  6 11:55:36 debian-hell kernel: [  809.381512] kobject: '6'
(ffff88012416c1a0): kobject_uevent_env
Dec  6 11:55:36 debian-hell kernel: [  809.381536] kobject: '6'
(ffff88012416c1a0): fill_kobj_path: path = '/kernel/uids/6'
Dec  6 11:55:36 debian-hell kernel: [  809.381567] kobject: '6'
(ffff88012416c1a0): kobject_cleanup
Dec  6 11:55:36 debian-hell kernel: [  809.381569] kobject: '6'
(ffff88012416c1a0): calling ktype release
Dec  6 11:55:36 debian-hell kernel: [  809.381570] kobject: '6': free name
Dec  6 12:00:21 debian-hell kernel: [ 1093.998048] kobject: '8:0:0:0'
(ffff880127158328): kobject_uevent_env
Dec  6 12:00:21 debian-hell kernel: [ 1093.998065] kobject: '8:0:0:0'
(ffff880127158328): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0'
Dec  6 12:00:21 debian-hell kernel: [ 1093.999189] kobject: 'sr0'
(ffff8801270f4458): kobject_uevent_env
Dec  6 12:00:21 debian-hell kernel: [ 1093.999214] kobject: 'sr0'
(ffff8801270f4458): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0/block/sr0'
Dec  6 12:00:23 debian-hell kernel: [ 1096.214488] kobject: '65534'
(ffff8800c392e060): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 12:00:23 debian-hell kernel: [ 1096.214501] kobject: '65534'
(ffff8800c392e060): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.214512] kobject: '65534'
(ffff8800c392e060): fill_kobj_path: path = '/kernel/uids/65534'
Dec  6 12:00:23 debian-hell kernel: [ 1096.724660] kobject: 'nls_base'
(ffffffffa02b6150): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 12:00:23 debian-hell kernel: [ 1096.725550] kobject: 'holders'
(ffff8800c3908d48): kobject_add_internal: parent: 'nls_base', set:
'<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.725575] kobject: 'nls_base'
(ffffffffa02b6150): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.725588] kobject: 'nls_base'
(ffffffffa02b6150): fill_kobj_path: path = '/module/nls_base'
Dec  6 12:00:23 debian-hell kernel: [ 1096.725635] kobject: 'notes'
(ffff8800c3908cc0): kobject_add_internal: parent: 'nls_base', set:
'<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.735427] kobject: 'udf'
(ffffffffa02ca5d0): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 12:00:23 debian-hell kernel: [ 1096.738775] kobject: 'holders'
(ffff8800c3908908): kobject_add_internal: parent: 'udf', set: '<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.738799] kobject: 'udf'
(ffffffffa02ca5d0): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.738827] kobject: 'udf'
(ffffffffa02ca5d0): fill_kobj_path: path = '/module/udf'
Dec  6 12:00:23 debian-hell kernel: [ 1096.738909] kobject: 'notes'
(ffff8800c3908220): kobject_add_internal: parent: 'udf', set: '<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.738981] kobject:
'udf_inode_cache' (ffff880114029120): kobject_add_internal: parent:
'slab', set: 'slab'
Dec  6 12:00:23 debian-hell kernel: [ 1096.739059] kobject:
'udf_inode_cache' (ffff880114029120): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.739079] kobject:
'udf_inode_cache' (ffff880114029120): fill_kobj_path: path =
'/kernel/slab/udf_inode_cache'
Dec  6 12:00:23 debian-hell kernel: [ 1096.939633] kobject:
'zlib_inflate' (ffffffffa02d0e50): kobject_add_internal: parent:
'module', set: 'module'
Dec  6 12:00:23 debian-hell kernel: [ 1096.940930] kobject: 'holders'
(ffff880037936110): kobject_add_internal: parent: 'zlib_inflate', set:
'<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.940953] kobject:
'zlib_inflate' (ffffffffa02d0e50): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.940969] kobject:
'zlib_inflate' (ffffffffa02d0e50): fill_kobj_path: path =
'/module/zlib_inflate'
Dec  6 12:00:23 debian-hell kernel: [ 1096.941024] kobject: 'notes'
(ffff8800379364c8): kobject_add_internal: parent: 'zlib_inflate', set:
'<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.948645] kobject: 'isofs'
(ffffffffa02d9d50): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 12:00:23 debian-hell kernel: [ 1096.950202] kobject: 'holders'
(ffff88012698ba18): kobject_add_internal: parent: 'isofs', set:
'<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.950213] kobject: 'isofs'
(ffffffffa02d9d50): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.950223] kobject: 'isofs'
(ffffffffa02d9d50): fill_kobj_path: path = '/module/isofs'
Dec  6 12:00:23 debian-hell kernel: [ 1096.950297] kobject: 'notes'
(ffff88012698b110): kobject_add_internal: parent: 'isofs', set:
'<NULL>'
Dec  6 12:00:23 debian-hell kernel: [ 1096.950381] kobject:
'isofs_inode_cache' (ffff88011402d240): kobject_add_internal: parent:
'slab', set: 'slab'
Dec  6 12:00:23 debian-hell kernel: [ 1096.950449] kobject:
'isofs_inode_cache' (ffff88011402d240): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.950467] kobject:
'isofs_inode_cache' (ffff88011402d240): fill_kobj_path: path =
'/kernel/slab/isofs_inode_cache'
Dec  6 12:00:23 debian-hell kernel: [ 1096.976668] kobject: '65534'
(ffff8800c392e060): kobject_uevent_env
Dec  6 12:00:23 debian-hell kernel: [ 1096.976681] kobject: '65534'
(ffff8800c392e060): fill_kobj_path: path = '/kernel/uids/65534'
Dec  6 12:00:23 debian-hell kernel: [ 1096.976710] kobject: '65534'
(ffff8800c392e060): kobject_cleanup
Dec  6 12:00:23 debian-hell kernel: [ 1096.976712] kobject: '65534'
(ffff8800c392e060): calling ktype release
Dec  6 12:00:23 debian-hell kernel: [ 1096.976713] kobject: '65534': free name
Dec  6 12:00:24 debian-hell kernel: [ 1097.180622] UDF-fs: No VRS found
Dec  6 12:00:24 debian-hell kernel: [ 1097.240353] UDF-fs: No VRS found
Dec  6 12:00:24 debian-hell kernel: [ 1097.263243] ISO 9660
Extensions: Microsoft Joliet Level 3
Dec  6 12:00:24 debian-hell kernel: [ 1097.276876] kobject: 'nls_utf8'
(ffffffffa02dd550): kobject_add_internal: parent: 'module', set:
'module'
Dec  6 12:00:24 debian-hell kernel: [ 1097.277503] kobject: 'holders'
(ffff8800378a4198): kobject_add_internal: parent: 'nls_utf8', set:
'<NULL>'
Dec  6 12:00:24 debian-hell kernel: [ 1097.277524] kobject: 'nls_utf8'
(ffffffffa02dd550): kobject_uevent_env
Dec  6 12:00:24 debian-hell kernel: [ 1097.277541] kobject: 'nls_utf8'
(ffffffffa02dd550): fill_kobj_path: path = '/module/nls_utf8'
Dec  6 12:00:24 debian-hell kernel: [ 1097.277599] kobject: 'notes'
(ffff8800378a42a8): kobject_add_internal: parent: 'nls_utf8', set:
'<NULL>'
Dec  6 12:00:24 debian-hell kernel: [ 1097.285906] ISOFS: changing to
secondary root
Dec  6 12:02:23 debian-hell kernel: [ 1215.996605] kobject: '3:0:0:0'
(ffff88012797b400): kobject_uevent_env
Dec  6 12:02:23 debian-hell kernel: [ 1215.996630] kobject: '3:0:0:0'
(ffff88012797b400): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0'
Dec  6 12:02:23 debian-hell kernel: [ 1215.997689] kobject: 'sr1'
(ffff880128d58a60): kobject_uevent_env
Dec  6 12:02:23 debian-hell kernel: [ 1215.997704] kobject: 'sr1'
(ffff880128d58a60): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0/block/sr1'
Dec  6 12:02:23 debian-hell kernel: [ 1216.045239] kobject: '65534'
(ffff8801268922e0): kobject_add_internal: parent: 'uids', set: 'uids'
Dec  6 12:02:23 debian-hell kernel: [ 1216.045259] kobject: '65534'
(ffff8801268922e0): kobject_uevent_env
Dec  6 12:02:23 debian-hell kernel: [ 1216.045271] kobject: '65534'
(ffff8801268922e0): fill_kobj_path: path = '/kernel/uids/65534'
Dec  6 12:02:23 debian-hell kernel: [ 1216.913884] kobject: '65534'
(ffff8801268922e0): kobject_uevent_env
Dec  6 12:02:23 debian-hell kernel: [ 1216.913903] kobject: '65534'
(ffff8801268922e0): fill_kobj_path: path = '/kernel/uids/65534'
Dec  6 12:02:23 debian-hell kernel: [ 1216.914717] kobject: '65534'
(ffff8801268922e0): kobject_cleanup
Dec  6 12:02:23 debian-hell kernel: [ 1216.914723] kobject: '65534'
(ffff8801268922e0): calling ktype release
Dec  6 12:02:23 debian-hell kernel: [ 1216.914726] kobject: '65534': free name
Dec  6 12:02:23 debian-hell kernel: [ 1216.959463] ISO 9660
Extensions: Microsoft Joliet Level 3
Dec  6 12:02:24 debian-hell kernel: [ 1216.986861] ISO 9660
Extensions: RRIP_1991A
Dec  6 12:06:35 debian-hell kernel: [ 1468.752780] kobject: '8:0:0:0'
(ffff880127158328): kobject_uevent_env
Dec  6 12:06:35 debian-hell kernel: [ 1468.752806] kobject: '8:0:0:0'
(ffff880127158328): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0'
Dec  6 12:06:35 debian-hell kernel: [ 1468.754752] kobject: 'sr0'
(ffff8801270f4458): kobject_uevent_env
Dec  6 12:06:35 debian-hell kernel: [ 1468.754786] kobject: 'sr0'
(ffff8801270f4458): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1c.1/0000:07:00.1/host8/target8:0:0/8:0:0:0/block/sr0'
Dec  6 12:06:40 debian-hell kernel: [ 1473.242155] kobject: '3:0:0:0'
(ffff88012797b400): kobject_uevent_env
Dec  6 12:06:40 debian-hell kernel: [ 1473.242188] kobject: '3:0:0:0'
(ffff88012797b400): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0'
Dec  6 12:06:40 debian-hell kernel: [ 1473.243752] kobject: 'sr1'
(ffff880128d58a60): kobject_uevent_env
Dec  6 12:06:40 debian-hell kernel: [ 1473.243789] kobject: 'sr1'
(ffff880128d58a60): fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1a.7/usb7/7-1/7-1:1.0/host3/target3:0:0/3:0:0:0/block/sr1'
Dec  6 15:21:33 debian-hell kernel: [13166.551252] r8169: eth1: link up
Dec  6 15:21:42 debian-hell kernel: [13175.208086] r8169: eth1: link up
Dec  6 15:30:11 debian-hell kernel: [13684.042313] r8169: eth1: link up
Dec  6 15:30:26 debian-hell kernel: [13699.860189] r8169: eth1: link up
Dec  6 18:20:59 debian-hell kernel: [23932.902930] r8169: eth1: link up
Dec  6 18:21:13 debian-hell kernel: [23946.049904] r8169: eth1: link up
Dec  6 19:38:36 debian-hell kernel: [28589.314031] r8169: eth1: link up
Dec  6 19:38:47 debian-hell kernel: [28600.413710] r8169: eth1: link up

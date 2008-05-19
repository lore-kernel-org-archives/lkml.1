Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbYESP0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbYESP0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYESP0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:26:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:11536 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbYESP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=RSg7s5YemKbJ0xeWIyhlY6p5xb89Jugeb2IR4x+EwtifxhiYxeaZiPIctH9K3igtUJcc2T9oL9GkW8OWU9aohiBkFVznx8oE5CN8jOsbdFySMnh+9dPgL4Dule+fRdoit8UfIPYjrgOeh9fsW9FlhByNjehLDUahgtiGgGe5GTM=
Message-ID: <48319C1F.6030005@gmail.com>
Date: Mon, 19 May 2008 17:26:23 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: 2.6.25: usb-storage unknown partition table issue
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i have a 8GB usb pen with several problem due to partition table.

if i create a primary one with fdisk, then format it works ok.
then i umount it, unplug, replug, no more partition detected.

I formatted it on Windows (same machine) and this some stress test, but 
it's brand new and it works.
The partition and the free space is correctly seen by qtparted and 
parted, but in the dmesg i see:

Initializing USB Mass Storage driver...
scsi10 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
scsi 10:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 
ANSI: 2
sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
sd 10:0:0:0: [sdc] Write Protect is off
sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
sd 10:0:0:0: [sdc] Assuming drive cache: write through
sd 10:0:0:0: [sdc] 15794176 512-byte hardware sectors (8087 MB)
sd 10:0:0:0: [sdc] Write Protect is off
sd 10:0:0:0: [sdc] Mode Sense: 00 00 00 00
sd 10:0:0:0: [sdc] Assuming drive cache: write through
 sdc: unknown partition table
sd 10:0:0:0: [sdc] Attached SCSI removable disk

This makes the partition unasable in my linux 2.6.25 (vanilla) system.
Another 1gb usbpen works perfectly.

Bus 004 Device 001: ID 1d6b:0001
Bus 005 Device 001: ID 1d6b:0001
Bus 002 Device 001: ID 1d6b:0001
Bus 003 Device 001: ID 1d6b:0001
Bus 001 Device 002: ID 1307:0165 Transcend Information, Inc.
Bus 001 Device 001: ID 1d6b:0002

Anything i can try?
It looks a scsi issue. And it's the first time i see the Mode Sense set 
to 0 for any usb storage device.

Please CC me i'm not subscribed

--
Patrizio Bassi
www.patriziobassi.it

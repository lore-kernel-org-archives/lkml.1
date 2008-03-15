Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYCOOOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYCOOOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 10:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYCOOOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 10:14:24 -0400
Received: from smtp-out1.libero.it ([212.52.84.41]:52401 "EHLO
	smtp-out1.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYCOOOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 10:14:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogTACV320esHwAl/2dsb2JhbAAIjHObPw
Date: Sat, 15 Mar 2008 15:14:21 +0100
Message-Id: <JXRZJX$1AEE2A8F9985911603E9009F67CA10F2@libero.it>
Subject: initramfs - unable to boot livcd from usb-cdrom devices (bug)
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "depaolis\.salvatore\@libero\.it" <depaolis.salvatore@libero.it>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-usb" <linux-usb@vger.kernel.org>
X-XaM3-API-Version: 4.3 (R1) (B3pl25)
X-SenderIP: 80.183.198.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all the ML

I got a travelmate with does not have an inner cdrom, so the only way to install linux is by using the usb-cdrom device provided with the laptop.

The problem is this one:

While booting the livecd, initramfs is loaded and it probe for devices and then would mount the new_root on the cdrom and eventually to unsquash a filesystem.

With this kind of device, there's more lag of time to firstly probe the usb and then the cdrom device. The result is that the device is mounted before is been probed showed the prompt of (initramfs)

I remember of an option for the kernel to delay the mount of the root, but it did not work to me with the cdrom.. I tried in this way root=/ rootdelay=10

Any help is really appreciated.
Regards
Sal


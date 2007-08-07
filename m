Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXHGUk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXHGUk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXHGUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:40:17 -0400
Received: from main.gmane.org ([80.91.229.2]:56248 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbXHGUkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:40:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Problems with USB disk
Date: Tue, 07 Aug 2007 22:26:15 +0200
Message-ID: <f9akh8$ori$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 62.79.44.136.adsl.gl.tiscali.dk
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having problems with a new 500 GB USB disk. It works, but sometimes I
get these in dmesg:


usb 1-3: reset high speed USB device using ehci_hcd and address 2
usb 5-1: USB disconnect, address 2
drivers/usb/class/usblp.c: usblp0: removed
sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
: ASC=0x4 ASCQ=0x2
end_request: I/O error, dev sda, sector 254148215
sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
: ASC=0x4 ASCQ=0x2
end_request: I/O error, dev sda, sector 252434023
EXT3-fs error (device sda1): ext3_find_entry: reading directory #15761836
offset 0


There's also a printer connected. This is on a pci/usb2 card. When the above
happens, I get I/O errors. When I mount the drive next, there are errors
and often missing files. Quite annoying!

Kernel is 2.6.21

What's going on?


Thanks,
Niels


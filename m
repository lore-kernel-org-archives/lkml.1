Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbXBYXrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbXBYXrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXBYXrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:47:51 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58190 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbXBYXru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:47:50 -0500
Date: Sun, 25 Feb 2007 15:44:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mario Vanoni <vanonim@alice.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.16.41 & 2.6.18.7 OK,   2.6.19.5 NOT,   2.6.18.8 KERNEL
 PANIC
Message-Id: <20070225154438.dbf695f0.randy.dunlap@oracle.com>
In-Reply-To: <45E1B3E6.60403@alice.it>
References: <45E05D54.10508@alice.it>
	<20070224201902.a2a7b3da.randy.dunlap@oracle.com>
	<45E1B3E6.60403@alice.it>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007 17:05:58 +0100 Mario Vanoni wrote:

> Randy Dunlap wrote:
> > On Sat, 24 Feb 2007 16:44:20 +0100 Mario Vanoni wrote:
> > 
> >> 2.6.18.7 vanilla & 2.6.16.41 vanilla:
> >> /dev/hda CD/DVD
> >> /dev/hda1 / IDE HD 160GB
> >> /dev/hda2 swap
> >> /dev/sda1 /xyz SATA HD 320GB
> >> /dev/sda2 swap
> >> /dev/sdb1 /zzz SATA HD 320GB
> >> /dev/sdb2 swap
> >> /dev/sdc1 /usb USB KEY 512MB
> 
> > For 2.6.19.*, does .config contain any CONFIG_ATA* entries?
> > FYI, in 2.6.19, CONFIG_SCSI_SATA* config symbols were renamed to
> > CONFIG_ATA*, so just using an oldconfig won't be sufficient
> > for SATA support.
> 
> You are 100% right, I was lazy, thanks for the gentle blame.
> 2.6.19.5 vanilla works perfectly, 2.6.20.1 vanilla too!
> 
> >> ---
> >> 2.6.18.8 vanilla: !!!
> >> screen eating leftmost characters, then
> >> kernel panic - not syncing: VFS: Unable to mount root fs on
> >> unknown-block(3,65)
> >> POWER SWITCH ultima ratio
> >> ---

What is (3,65) supposed to be?  devices.txt says that it's /dev/hdb1.
I don't see that listed anywhere here...

> Strange error, due to a partially corrupted MBR (?):
> 2.6.19.5 with incorrect .config, lilo, SATA missing
> reboot with old 2.6.18.7, OK
> 2.6.18.8 with old .config from 2.6.18.6,
> lilo objects not seeing /dev/sdb and /dev/sdc,
> reboot and kernel panic,
> reboot with 2.6.18.7, OK
> 2.6.18.8 make mrproper and rm -r /lib/modules/2.6.18.8
> make bzImage etc., lilo: 2.6.18.8 works perfectly.


---
~Randy

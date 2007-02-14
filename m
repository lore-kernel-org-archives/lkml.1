Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbXBNQQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbXBNQQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbXBNQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:16:13 -0500
Received: from smtp19.orange.fr ([80.12.242.1]:23760 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357AbXBNQQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:16:12 -0500
X-ME-UUID: 20070214161608474.73B5E1C00049@mwinf1903.orange.fr
Message-ID: <45D335A2.5080105@wanadoo.fr>
Date: Wed, 14 Feb 2007 17:15:30 +0100
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: no swap!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

After compiling the kernel, I discover that my computer don't use the swap.
So, I try a cat .config |grep SW, and I got :
CONFIG_SWAP=y
# CONFIG_X86_VISWS is not set
CONFIG_X86_BSWAP=y
CONFIG_SUSPEND2_SWAP=y
CONFIG_SUSPEND2_REPLACE_SWSUSP=y
# CONFIG_AGP_SWORKS is not set
CONFIG_USB_AUERSWALD=m

This is my fstab :
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
# /dev/hda1 -- converted during upgrade to edgy
UUID=c0808eb9-790a-4a20-a3a2-26a4204d0fb2 / ext3 
defaults,errors=remount-ro 0 1
# /dev/hda5 -- converted during upgrade to edgy
UUID=dfcca30e-3b78-4110-b578-9b8835ecf062 none swap sw 0 0
#/dev/hda5	none	swap	sw	0	0
/dev/hdc        /media/cdrom0   udf,iso9660 user,noauto     0       0
/dev/fd0        /media/floppy0  auto    rw,user,noauto  0       0


Is it a problem of LVM or RAID ? I don't understand that very well...

Thanks a lot,
Thibaud.


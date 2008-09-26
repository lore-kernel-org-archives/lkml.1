Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYIZTmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYIZTmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYIZTl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:41:59 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:59601 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYIZTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:41:58 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Fri, 26 Sep 2008 21:42:01 +0200
User-Agent: KMail/1.9.5
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809192053.36760.stefan.bauer@cs.tu-chemnitz.de> <200809200210.33597.j@jannau.net>
In-Reply-To: <200809200210.33597.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809262142.01801.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: bd263acef5c49e825d8b5debdb1b160d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 20 September 2008 02:10, Janne Grunau wrote:
> but lirc serial still doesn't work after
> bc2039245c6390bd414a61c9395604c4155a58c6. I'll look at it tomorrow.

just to tell you that I'm still there... :) Todays git 
(a842c8095aad7b71ffcd1e426185e53661d758c7) is also giving me this at first 
access to the device by lircd:

------------[ cut here ]------------
WARNING: at drivers/input/lirc/lirc_dev.h:37
lirc_buffer_clear+0x2c/0x30 [lirc_dev]()
calling lirc_buffer_clear on an uninitialized lirc_buffer
Modules linked in: lirc_serial lirc_dev ves1820 arc4 ecb crypto_blkcipher 
cryptomgr crypto_algapi rt61pci rt2x00pci rt2x00lib led_class dvb_ttpci 
saa7146_vv saa7146 videobuf_dma_sg mac80211 videobuf_core videodev ehci_hcd 
uhci_hcd ttpci_eeprom cfg80211 eeprom_93cx6 [last unloaded: lirc_dev]
Pid: 5144, comm: lircd Not tainted 2.6.27-rc5 #7
 [<c01151ce>] warn_slowpath+0x61/0x84
 [<c015971f>] __d_lookup+0x8b/0xbf
 [<c0151f26>] do_lookup+0x40/0x92
 [<c0158f6d>] dput+0x15/0x8d
 [<c0153533>] __link_path_walk+0x7ad/0x8b4
 [<c0153533>] __link_path_walk+0x7ad/0x8b4
 [<c01de0c1>] kobject_get+0xf/0x13
 [<c014dfbb>] cdev_get+0x1b/0x2d
 [<c014dfd4>] exact_lock+0x7/0xd
 [<c0242154>] kobj_lookup+0xda/0x104
 [<ca9fa15a>] lirc_buffer_clear+0x2c/0x30 [lirc_dev]
 [<ca9fa4f4>] lirc_dev_fop_open+0x9e/0x135 [lirc_dev]
 [<c014e15c>] chrdev_open+0xc1/0xf6
 [<c014e09b>] chrdev_open+0x0/0xf6
 [<c014b052>] __dentry_open+0xf2/0x1da
 [<c014b156>] nameidata_to_filp+0x1c/0x2c
 [<c01544ae>] do_filp_open+0x28b/0x545
 [<c015bc37>] alloc_fd+0x46/0xad
 [<c014ae8d>] do_sys_open+0x42/0xb6
 [<c014af45>] sys_open+0x1e/0x23
 [<c010297d>] sysenter_do_call+0x12/0x25
 [<c02f0000>] ioctl_standard_iw_point+0x12d/0x200
 =======================
---[ end trace 6c8eb5cbb580deaf ]---

Regards,
Stefan

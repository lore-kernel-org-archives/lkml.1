Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbZAGV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbZAGV5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZAGV5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:57:25 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:6867 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZAGV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:57:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=Lj3GsXAd2ila6kdxGHj3vE38PaO5MD3YbBRKGkR/3c6IJ58K/DOEP3/CoULGdAbBjX
         P0o0vodtiN+qogntupKJOM861Ade9CqEuqyHxbcBG8+hNfvz3qmNsVsuhoNXlBEu8KC7
         +wV2Q2VHzUDd2cBSzawj7f5esBYt7e5CiK9LM=
Message-ID: <86802c440901071357j3dd03b2ax9b79735fd374e94d@mail.gmail.com>
Date: Wed, 7 Jan 2009 13:57:22 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: initrd panic
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 84c4b120cddf78de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.000000] Bootmem setup node 0 0000000000000000-0000000828000000
[    0.000000]   NODE_DATA [000000000008b580 - 000000000009057f]
[    0.000000]   bootmap [00000000011e4000 -  00000000012e8fff] pages 105
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0828000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00011e3010]    TEXT DATA BSS ==>
[0000200000 - 00011e3010]
[    0.000000]   #3 [007ddb0000 - 007ffff746]          RAMDISK ==>
[007ddb0000 - 007ffff746]
[    0.000000]   #4 [0000095400 - 0000100000]    BIOS reserved ==>
[0000095400 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==>
[0000008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE ==>
[000000a000 - 000000b000]
[    0.000000]   #7 [0000001000 - 000000106c]        ACPI SLIT ==>
[0000001000 - 000000106c]
[    0.000000]   #8 [000000b000 - 000008b580]       MEMNODEMAP ==>
[000000b000 - 000008b580]
...
[   26.878476] calling  populate_rootfs+0x0/0xef @ 1
[   26.883266] checking if image is initramfs...it isn't (no cpio
magic); looks like an initrd
[   26.925007] Freeing initrd memory: 35133k freed
[   26.947946] initcall populate_rootfs+0x0/0xef returned 0 after 63247 usecs
...
[   99.714363] RAMDISK: gzip image found at block 0
[  100.831449] RAMDISK: incomplete write (1880 != 1999)
[  100.836421] write error
[  101.092202] kjournald starting.  Commit interval 5 seconds
[  101.092217] EXT3 FS on ram0, internal journal
[  101.092227] EXT3-fs: mounted filesystem with ordered data mode.
[  101.092244] VFS: Mounted root (ext3 filesystem) on device 1:0.
[  101.092262] Freeing unused kernel memory: 448k freed
[  101.092586] init_special_inode: bogus i_mode (177777)
[  101.092591] Warning: unable to open an initial console.
[  101.092607] init_special_inode: bogus i_mode (177777)
[  101.092618] init_special_inode: bogus i_mode (177777)
[  101.092630] init_special_inode: bogus i_mode (177777)
[  101.092635] Kernel panic - not syncing: No init found.  Try passing
init= option to kernel.
[  101.092639] Pid: 1, comm: swapper Not tainted
2.6.28-tip-07660-g1bc0566-dirty #366
[  101.092641] Call Trace:
[  101.092655]  [<ffffffff809cc9be>] panic+0x75/0x12c
[  101.092662]  [<ffffffff802092a8>] name_to_dev_t+0x0/0x1f0
[  101.092668]  [<ffffffff8022c05a>] ? child_rip+0xa/0x20
[  101.092671]  [<ffffffff8022c050>] ? child_rip+0x0/0x20


wonder if LZMA B2ZIP etc into tip/master today broke it?

YH

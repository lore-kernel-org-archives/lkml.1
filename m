Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbYBLL24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbYBLL24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbYBLL2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:28:43 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:36410 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356AbYBLL2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=e6esQfzorY9SqmUt5t3YXUyPUjMixF54JRqB92g7vyejTQnU2rW1J+/G03q/tgbzIKu6UwOCNo6Wt9ubo2tOZbmGiZq/uO2LtIKHYJte6MTljQcfbYksezgrBPWSVzMgCiWEaEnksHDqeTIdm9wqLzritH1geokOFH8IDwXCgTs=
Message-ID: <86802c440802120328i2e60ba3brbe7fdec87d4cce4a@mail.gmail.com>
Date: Tue, 12 Feb 2008 03:28:40 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: /initrd.img
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any limitation about size of
/initrd.img that saved by populate_rootfs ?

i got

RAMDISK: Compressed image found at block 0
RAMDISK: incomplete write (-28 != 2048) 134217728
crc error
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 388k freed
init_special_inode: bogus i_mode (177777)
Warning: unable to open an initial console.
init_special_inode: bogus i_mode (177777)
init_special_inode: bogus i_mode (177777)
Kernel panic - not syncing: No init found.  Try passing init= option to kernel.

before that
checking if image is initramfs... it isn't (no cpio magic); looks like an initrd
Freeing initrd memory: 25735k freed.

that only happen one system (64G RAM) and SLUB.

if using SLAB, it works well.

somewhere the ramdisk or /initrd.img get corrupted..

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763320AbYBLSBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763320AbYBLSBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYBLSA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:00:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbYBLSA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:00:56 -0500
Message-ID: <47B1DD36.6090401@zytor.com>
Date: Tue, 12 Feb 2008 09:53:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /initrd.img
References: <86802c440802120328i2e60ba3brbe7fdec87d4cce4a@mail.gmail.com>
In-Reply-To: <86802c440802120328i2e60ba3brbe7fdec87d4cce4a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> any limitation about size of
> /initrd.img that saved by populate_rootfs ?
> 
> i got
> 
> RAMDISK: Compressed image found at block 0
> RAMDISK: incomplete write (-28 != 2048) 134217728
> crc error
> VFS: Mounted root (ext2 filesystem).
> Freeing unused kernel memory: 388k freed
> init_special_inode: bogus i_mode (177777)
> Warning: unable to open an initial console.
> init_special_inode: bogus i_mode (177777)
> init_special_inode: bogus i_mode (177777)
> Kernel panic - not syncing: No init found.  Try passing init= option to kernel.
> 
> before that
> checking if image is initramfs... it isn't (no cpio magic); looks like an initrd
> Freeing initrd memory: 25735k freed.
> 
> that only happen one system (64G RAM) and SLUB.
> 
> if using SLAB, it works well.
> 
> somewhere the ramdisk or /initrd.img get corrupted..
> 

Assuming a 64-bit system, that's *supposed* to work.  Doesn't mean 
anything that weird has been tested.

It could be a SLUB bug, or it could be memory not being properly defended.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZCUKlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZCUKlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZCUKk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:40:57 -0400
Received: from ppp-110-39.adsl.restena.lu ([158.64.110.39]:42366 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZCUKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:40:56 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Mar 2009 06:40:56 EDT
Date: Sat, 21 Mar 2009 11:33:15 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: phillip@lougher.demon.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: SquashFS io errors -  zlib_inflate tried to decompress too much
 data
Message-ID: <20090321113315.47562aac@neptune.home>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

With 2.6.29-rc7-git5 (x86, 32bit) I get the following errors on assumed
correct squashfs images (generated with mksquashfs from CVS, dated
2009-03-14)

[ 3481.692558] SQUASHFS error: zlib_inflate tried to decompress too much data, expected 8192 bytes.  Zlib data probably corrupt
[ 3481.692571] SQUASHFS error: squashfs_read_data failed to read block 0x29375e0
[ 3481.692579] SQUASHFS error: Unable to read metadata cache entry [29375e0]
[ 3481.692586] SQUASHFS error: Unable to read inode 0x6a04a05ed

The same happens on 2.6.28.8 with all squashfs patches from 2.6.29-rc8
applied to it (x86, 64bit).

If useful I can provide the image (44MiB), it's an image of Gentoo
portage tree.

Bruno

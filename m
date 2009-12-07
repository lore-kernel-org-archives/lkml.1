Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbZLGIZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbZLGIZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbZLGIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:25:48 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:45501 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758962AbZLGIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:25:47 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems 
Message-Id: <E1NHYun-000287-Vq@dylan.lougher.demon.co.uk>
From: root <root@lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 08:25:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches add LZMA decompression support to Squashfs, using the
in-kernel LZMA decompression library.

The patches also add a decompression framework to Squashfs.
This allows LZMA decompression to be added cleanly, and it allows
additional decompressors to be easily added in the future.

To enable the in-kernel LZMA decompression code to be used by Squashfs,
there are two patches to the lzma code itself: one to make lzma available
to non-init code, and one to make lzma reentrant.  These are obviously
not restricted to Squashfs, but are needed by any non-init code that
may wish to use lzma compression.

These patches are available in my squashfs-devel git tree in a slightly
different format (these patches have been refactored for posting, they'll
be put into a git tree ASAP).

http://git.kernel.org/?p=linux/kernel/git/pkl/squashfs-devel.git;a=summary

I would like to thank the CE Linux Forum (CELF) for supporting this work.

Thanks

Phillip


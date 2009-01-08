Return-Path: <linux-kernel-owner+w=401wt.eu-S1763721AbZAHXa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbZAHXa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZAHX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:29:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZAHX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:29:11 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: Alain Knaff <alain@knaff.lu>, Sam Ravnborg <sam@ravnborg.org>,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Additional patches applied to tip:x86/setup-lzma
Date: Thu,  8 Jan 2009 15:28:57 -0800
Message-Id: <1231457340-18045-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have applied the following additional patches to tip:x86/setup-lzma,
the bzip2/lzma compression branch.  The full set of patches now looks
like:

Alain Knaff (5):
      bzip2/lzma: library support for gzip, bzip2 and lzma decompression
      bzip2/lzma: config and initramfs support for bzip2/lzma decompression
      bzip2/lzma: x86 kernel compression support
      bzip2/lzma: fix built-in initramfs vs CONFIG_RD_GZIP
      bzip2/lzma: fix decompress_inflate.c vs
      multi-block-with-embedded-filename

H. Peter Anvin (8):
      bzip2/lzma: use a table to search for initramfs compression formats
      bzip2/lzma: handle failures from bzip2 and lzma correctly
      bzip2/lzma: make config machinery an arch configurable
      bzip2/lzma: proper Kconfig dependencies for the ramdisk options
      bzip2/lzma: DECOMPRESS_GZIP should select ZLIB_INFLATE
      bzip2/lzma: move initrd/ramfs options out of BLK_DEV
      bzip2/lzma: fix constant in decompress_inflate
      bzip2/lzma: centralize format detection

Posted here for review.


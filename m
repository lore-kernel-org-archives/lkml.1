Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZLNVsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZLNVsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbZLNVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:48:07 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:47312 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758271AbZLNVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:48:05 -0500
Date: Mon, 14 Dec 2009 21:45:19 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Cc: phillip@lougher.demon.co.uk, mingo@elte.hu,
       albin.tonnerre@free-electrons.com
Subject: [PATCH 0/3] bzip2/lzma/gzip/initramfs: NULL pointer bugs and
 missing error checks
Message-ID: <4b26b1ef.4UsgG1v4tcHL5wwS%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

The following patches fix up a number of NULL pointer bugs amd missing
error checks.

Thanks

Phillip

  bzip2/lzma/gzip: pre-boot malloc doesn't return NULL on failure
  bzip2: Add missing checks for malloc returning NULL
  initramfs: add missing decompressor error check

---
 include/linux/decompress/mm.h |    4 ++--
 init/initramfs.c              |   10 ++++++----
 lib/decompress_bunzip2.c      |   10 +++++++++-
 3 files changed, 17 insertions(+), 7 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZFWE60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZFWE60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZFWE6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:58:19 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:56561 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbZFWE6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:58:18 -0400
To: torvalds@linux-foundation.org, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alain@knaff.lu
Subject: [PATCH 0/3] bzip2/lzma/gzip: Remove bugs/hacks and tidy up code
Message-Id: <E1MIy5M-0003bD-Hg@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Tue, 23 Jun 2009 05:58:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This small patch series fixes a number of bugs/hacks present in the
new decompressor code, and improves the API commenting/consistency.

bzip2/lzma/gzip: Fix comments describing decompressor API
bzip2/lzma: Remove nasty uncompressed size hack in pre-boot environment
lzma/gzip: Fix potential oops when input data is truncated

Thanks

Phillip

 include/linux/decompress/generic.h |   32 +++++++++++++++++++-------------
 lib/decompress_bunzip2.c           |   22 ++++++++++++++++------
 lib/decompress_inflate.c           |   16 ++++++++++++----
 lib/decompress_unlzma.c            |   31 +++++++++++++++++++++++++------
 4 files changed, 72 insertions(+), 29 deletions(-)

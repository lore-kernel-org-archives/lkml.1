Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXB0XQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXB0XQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXB0XQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:16:14 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:50778 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXB0XQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:16:13 -0500
Message-Id: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 00/22] misc VFS/VM patches and fuse writable shared mapping support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The first part of this series (1-7) contains miscellaneous patches,
some of which are needed for fuse writable mmap to work correctly.

Some of these are resends of patches already in -mm, with minor
updates.

The rest of the series adds shared writable mapping support to fuse,
with some write performance improvements thrown in.  Survives
fsx-linux, LTP and bash-shared-mappings.

There are dependencies on patches in -mm, notably

  per-backing_dev-dirty-and-writeback-page-accounting.patch

--

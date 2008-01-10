Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbYAJWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbYAJWIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbYAJWIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:08:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:33091 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561AbYAJWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=izeSi43GpCScl1BB5+LT7lYFlLMSf2J2z/Io80r2zgBu+u9nCCH00nihnDK9zVM9hPXyaPwrYznAsNvNj1k0vFTItj/hr/d5gjfaBN74MXK+o88xBQo8chvTFwlWmKVRQyprwSS4TQ4ziu5uncDTTRZpMM7snTaf09oxUsFOBSg=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 08/16] udf: fix coding style
Date: Thu, 10 Jan 2008 23:06:24 +0100
Message-Id: <1200002792-8449-9-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix coding style errors found by checkpatch:
- assignments in if conditions
- braces {} around single statement blocks
- no spaces after commas
- printks without KERN_*
- lines longer than 80 characters
- spaces between "type *" and variable name

before: 192 errors, 561 warnings, 8987 lines checked
after: 1 errors, 38 warnings, 9468 lines checked

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/udf/balloc.c    |  231 +++++++++++-------
 fs/udf/crc.c       |    2 +-
 fs/udf/directory.c |   83 ++++---
 fs/udf/file.c      |   18 +-
 fs/udf/ialloc.c    |   24 ++-
 fs/udf/inode.c     |  665 +++++++++++++++++++++++++++++++---------------------
 fs/udf/misc.c      |   76 ++++---
 fs/udf/namei.c     |  298 ++++++++++++++----------
 fs/udf/partition.c |  160 ++++++++-----
 fs/udf/super.c     |  383 +++++++++++++++++++-----------
 fs/udf/symlink.c   |    3 +-
 fs/udf/truncate.c  |   58 +++--
 fs/udf/udftime.c   |   59 +++---
 fs/udf/unicode.c   |   85 ++++---
 14 files changed, 1311 insertions(+), 834 deletions(-)

patch (160kB) available at: http://www.kadu.net/~joi/kernel/2008.01.10/0008-udf-fix-coding-style.patch
md5: 00816fa02cf2541bee51e71a05d9dd94

Tell me if I should post it to LKML...

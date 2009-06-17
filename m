Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZFQUpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZFQUpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761365AbZFQUpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:45:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:41469 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbZFQUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:45:09 -0400
From: Jan Blunck <jblunck@suse.de>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       vaurora@redhat.com, hch@lst.de, miklos@szeredi.hu
Subject: [PATCH] Preparation work for VFS based union mounts
Date: Wed, 17 Jun 2009 22:45:04 +0200
Message-Id: <1245271510-31542-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,
here are some patches that are indenpendant from but necessary for the union
mount patch set. Valerie and I think they are ok to go in separately from the
rest of the patches.

Thanks,
Jan

Jan Blunck (6):
  VFS: BUG() if somebody tries to rehash an already hashed dentry
  VFS: propagate mnt_flags into do_loopback
  VFS: Make lookup_hash() return a struct path
  VFS: Remove unnecessary micro-optimization in cached_lookup()
  VFS: Make real_lookup() return a struct path
  VFS: Introduce dput() variant that maintains a kill-list

 fs/dcache.c    |  116 ++++++++++++++++++++++++++++---
 fs/namei.c     |  209 +++++++++++++++++++++++++++++++-------------------------
 fs/namespace.c |    7 +-
 3 files changed, 225 insertions(+), 107 deletions(-)


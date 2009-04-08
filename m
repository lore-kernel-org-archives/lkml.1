Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZDHNuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZDHNuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZDHNuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:50:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40098 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399AbZDHNt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:49:59 -0400
X-Sasl-enc: gJxxBHIHX6K8PQUD37RU/O2Q5EgWXrCi2naKx8ZXmU0P 1239198598
Message-ID: <49DCAB84.4030802@fastmail.fm>
Date: Wed, 08 Apr 2009 14:49:56 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 04/56] befs: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080426p71cf193ei5e3806e3781336d2@mail.gmail.com>
In-Reply-To: <36ca99e90904080426p71cf193ei5e3806e3781336d2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heres the fixed patch

Thanks

Jack

befs: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 fs/befs/linuxvfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 76afd0d..e8b56a1 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -277,8 +277,7 @@ static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
         struct befs_inode_info *bi;
-        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
-                            GFP_KERNEL);
+        bi = kmem_cache_alloc(befs_inode_cachep, GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;

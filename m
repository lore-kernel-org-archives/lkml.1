Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZFDIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZFDIuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbZFDItC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:02 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56727 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379AbZFDIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:48:56 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 00/17] abstract out the super block clean/dirty state
Date: Thu,  4 Jun 2009 13:41:37 +0300
Message-Id: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
X-OriginalArrivalTime: 04 Jun 2009 08:48:34.0810 (UTC) FILETIME=[3EC4B5A0:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Hi,

here is a set of trivial patches which encapsulate the 'sb->s_dirt' variable
into 3 new helper VFS functions:

* static inline void mark_sb_dirty(struct super_block *sb)
* static inline void mark_sb_clean(struct super_block *sb)
* static inline int sb_is_dirty(struct super_block *sb)

With these patches the whole Linux kernel tree has only 3 places where
'sb->s_dirt' is referred.

These patches were sent as part of periodic write-back optimization series here:
http://marc.info/?l=linux-kernel&m=124342331127886&w=2

Because of the overlap with Jens' "per-bdi write-back" work, I have to work
on top of Jens' patches. However, it would be easier for me if my preparation
"abstracting sb->s_dirt" patches were merged earlier, at 2.6.31 merge window.
I think they make sense in general. I would then continue working on the second
part separately.

Thanks.

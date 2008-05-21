Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbYEURQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbYEURQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764964AbYEURPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33046 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbYEURPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:48 -0400
Message-Id: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:14:58 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 00/14] vfs: permission API cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highlights are:

 - remove nameidata from the i_op->permission() method
 - remove nameidata passing and consolidate permission()/
   vfs_permission()/file_permission() API

It's all fairly trivial stuff, but I will do some LTP testing on it.

This series is based on the vfs-cleanups(*) tree.  If no problems are
found, I'll commit the patches to that tree.

Thanks,
Miklos

(*) git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups

--

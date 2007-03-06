Return-Path: <linux-kernel-owner+w=401wt.eu-S965459AbXCFSGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbXCFSGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXCFSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:06:04 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:39790 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965446AbXCFSGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:06:01 -0500
Message-Id: <20070306180443.669036741@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 Mar 2007 19:04:43 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 0/8] VFS/VM patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's a new patch, which fixes the race in clear_page_dirty_for_io()
and cleans up the page dirtying logic.  And the mmap mtime/ctime
update patch has seen much improvement.  The others are resends and
fixes.

I'm not resending the fuse writable mmap patches until the fate of the
deadlock fixes is decided.

Thanks
Miklos

--

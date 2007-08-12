Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbXHLJWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbXHLJWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763306AbXHLJVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:18 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37038 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758551AbXHLJVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:12 -0400
Message-ID: <386910467.21100@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070812091120.189651872@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 17:11:20 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: "Cc: Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/6] writeback time order/delay fixes take 3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew and Ken,

Here are some more experiments on the writeback stuff.
Comments are highly welcome~ 

writeback fixes:
[PATCH 1/6] writeback: fix time ordering of the per superblock inode lists 8   
[PATCH 2/6] writeback: fix ntfs with sb_has_dirty_inodes()                     
[PATCH 3/6] writeback: remove pages_skipped accounting in __block_write_full_pa

debug codes:
[PATCH 4/6] check dirty inode list                                             
[PATCH 5/6] prevent time-ordering warnings                                     
[PATCH 6/6] track redirty_tail() calls                                         

Thank you,
Fengguang
-- 

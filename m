Return-Path: <linux-kernel-owner+w=401wt.eu-S1030533AbXBOSwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030533AbXBOSwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030539AbXBOSwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:52:31 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:44915 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030533AbXBOSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:52:30 -0500
Date: Thu, 15 Feb 2007 19:52:28 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Cc: Linux NFS mailing list <nfs@lists.sourceforge.net>
Subject: 2.6.19.2 nfs BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
Message-ID: <20070215185228.GA3181@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI,

Just captured this one, I'm not sure it's NFS at fault because I saw
at least another AIO related mm/truncate.c:398 report with a totally
different stack trace.

The machine seems still running happily, as usual with a considerable
load. kernel is tainted by fglrx.

kernel: BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
kernel:  [<c0104897>] dump_trace+0x227/0x240
kernel:  [<c010498f>] show_trace_log_lvl+0x2f/0x50
kernel:  [<c01049d7>] show_trace+0x27/0x30
kernel:  [<c0104b06>] dump_stack+0x26/0x30
kernel:  [<c015a495>] invalidate_inode_pages2_range+0x305/0x310
kernel:  [<c015a4c1>] invalidate_inode_pages2+0x21/0x30
kernel:  [<c01f7aa8>] nfs_revalidate_mapping+0x98/0x180
kernel:  [<c01f5726>] nfs_file_read+0x46/0xb0
kernel:  [<c017441e>] do_sync_read+0xde/0x130
kernel:  [<c0174511>] vfs_read+0xa1/0x1b0
kernel:  [<c0174947>] sys_read+0x47/0x70
kernel:  [<c0103387>] syscall_call+0x7/0xb
kernel:  [<b7ec0cbe>] 0xb7ec0cbe
kernel:  =======================

-- 
Frank

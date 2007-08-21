Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXHUG2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXHUG2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbXHUG2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:28:39 -0400
Received: from nn7.de ([85.214.94.156]:44890 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbXHUG2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:28:38 -0400
Subject: Bad pte = e900b50d, process = ???
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Aug 2007 08:18:41 +0200
Message-Id: <1187677121.18257.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I suddenly got flodded with

Bad pte = e900b50d, process = ???, vm_flags = 100173, vaddr = bfc87ee2
 [<c0146ae9>] vm_normal_page+0x3e/0x53
 [<c0146f6a>] follow_page+0x90/0x147
 [<c01483d3>] get_user_pages+0x20f/0x261
 [<c0148e7c>] access_process_vm+0x7e/0x163
 [<c014a8af>] vma_merge+0x171/0x17f
 [<c0189509>] proc_pid_cmdline+0x57/0xe7
 [<c0189f73>] proc_info_read+0x4a/0x9c
 [<c0189f29>] proc_info_read+0x0/0x9c
 [<c0157a56>] vfs_read+0xa6/0x128
 [<c0157dc0>] sys_read+0x41/0x67
 [<c0103ce6>] syscall_call+0x7/0xb
 =======================

until the machine become unresponsive... 

Has anyone seen this before/what are the reasons for this ?

This is on kernel 2.6.22.1...

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.

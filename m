Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZHMPmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZHMPmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZHMPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:42:00 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:48743 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZHMPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vdzrqPk2fy52djPy/zFVwQgViF9NeDEGQqGWVExAACLBsZDZRK25E3u4ohjKn46/Gy
         wx20E5viRLyfRaWJlk99kCxaOsNPWfyyp1QjUsUA/+UZyw5bX8ACZwQIFKLq9ebuoe00
         txPbXFGKTv1HQmZ9VrrT7dsKaFX5mP2LoSpOY=
Message-ID: <4A84345D.60506@gmail.com>
Date: Thu, 13 Aug 2009 08:42:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: system gets stuck in a lock during boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted already and had no reply,
I cannot boot my system with the latest git

seems to be stuck in some lock:

[   0.655640] [<ffffffff81440c33>] panic+0x84/0x129
[   0.655883] [<ffffffff81063f96>]  do_exit+0x84/0x67e
[   0.656125] [<ffffffff81445044>] oops_end+0x9c/0xb7
[   0.656368] [<ffffffff81044a6c>] no_context+0x200/0x223
[   0.656611] [<ffffffff81442d3d>] ? __mutex_lock_slowpath+0x226/0x249
[   0.656848] [<ffffffff81044c36>] __bad_area_nosemaphore+0x1a7/0x1e1
[   0.657097] [<ffffffff81442b01>]? mutex_unlock+0x1c/0x32
[   0.657097] [<ffffffff811ce094>] ? inode_doinit_with_dentry+0x533/0x5be
[   0.657579] [<ffffffff81443ee0>] ? _spin_unlock+0x1c/0x32
[   0.657822] [<ffffffff81044c91>] bad_area_nosemaphore+0x2a/0x40
[   0.658066] [<ffffffff811ce149>] ? selinux_d_instantiate+0x2a/0x40
[   0.658309] [<ffffffff8144687d>] do_page_fault+0x192/0x2dd
[   0.658549] [<ffffffff814444cf>] page_fault+0x1f/0x30
[   0.658791] [<ffffffff8120e856>] ? strcmp+0x17/0x46
[   0.659040] [<ffffffff810b9ca0>] event_create_dir+0x49/0x37b
[   0.659276] [<ffffffff81696f0a>] ? event_trace_init+0x0/0x1a2
[   0.659519] [<ffffffff81697061>] event_trace_init+0x157/0x1a2
[   0.659762] [<ffffffff81696f0a>] ? event_trace_init+0x0/0x1a2
[   0.660008] [<ffffffff810091db>] do_one_initcall+0x65/0x14e
[   0.660251] [<ffffffff81140000>] ? proc_set_super+0x49/0x5d
[   0.660488] [<ffffffff8167ef53>] kernel_init+0x160/0x1cc
[   0.660731] [<ffffffff8102801a>] child_rip+0xa/0x20
[   0.660973] [<ffffffff8167edf3>] ? kernel_init+0x0/0x1cc
[   0.661220] [<ffffffff81028010>] ? child_rip+0x0/0x20



seems my other machine boots just fine, maybe this is something
with x86_64.

Justin P. Mattock

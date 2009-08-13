Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZHMFTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZHMFTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 01:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZHMFTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 01:19:46 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:63514 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZHMFTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 01:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=n5njpktAqNaLjFrjil5bvgyMGK2VzNUjypzRLDEX0wPHyjN4l+VAiSZ0xuOeFCq3kr
         Qp5DUkamgIbFDUsCzeyQTSZdEFqWqEdY/ZjFeJL7OBdx3jk+S6taewyzITgNc1luZp1T
         KcfzFrqIp2KRDVarY/F3KWD+CAFQ7ZZVbPK5c=
Message-ID: <4A83A285.8040000@gmail.com>
Date: Wed, 12 Aug 2009 22:20:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: latest git fried my x86_64 imac
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't the 1394 cable to attach my other device
(since the imac has some square looking thing)
to see if I can grab the boot log for this stuckage.

I'll write it down manually, and then tomorrow
or when I get a chance see if I can setup the debug
mechanism for 1394
to capture the whole message.


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


hopefully the numbers are correct.

Justin P. Mattock








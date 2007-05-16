Return-Path: <linux-kernel-owner+w=401wt.eu-S1761028AbXEPMol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028AbXEPMol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbXEPMof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:44:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:34108 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbXEPMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YBjgmcdFEoeoX0IEAnHOWnBK1JNpWeQrBwtT8nm8BP3pTgWrbI6r+kVPMQNg9U1oIr3umMxUzPyt47YD2TByaxvaBd8ApG1W0obNKyQxr+vvL/6Af8yZL6iJ3XCQULVPur8syYoXYLvJ86t26wv+rw28Hqwk9//4MfkSaY39jro=
Message-ID: <464AFCC6.5030208@gmail.com>
Date: Wed, 16 May 2007 14:44:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no
Subject: Re: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464AF4A6.5060000@gmail.com> <464AFB81.5050109@yahoo.com.au>
In-Reply-To: <464AFB81.5050109@yahoo.com.au>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin napsal(a):
> Jiri Slaby wrote:
>> Andrew Morton napsal(a):
>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>>
>>
>>
>> I've got this in dmesg:
>>
>> BUG: at /local/xslaby/xxx/mm/page-writeback.c:829
>> __set_page_dirty_nobuffers()
>>  [<c010531e>] dump_trace+0x1ce/0x200
>>  [<c010536a>] show_trace_log_lvl+0x1a/0x30
>>  [<c0106012>] show_trace+0x12/0x20
>>  [<c0106086>] dump_stack+0x16/0x20
>>  [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>>  [<c0155690>] redirty_page_for_writepage+0x10/0x20
>>  [<c01938fc>] __block_write_full_page+0x20c/0x330
>>  [<c0193b0a>] block_write_full_page+0xea/0x100
>>  [<c0196c82>] blkdev_writepage+0x12/0x20
>>  [<c015539e>] __writepage+0xe/0x30
>>  [<c01558c2>] write_cache_pages+0x222/0x340
>>  [<c0155a03>] generic_writepages+0x23/0x30
>>  [<c0155a3e>] do_writepages+0x2e/0x50
>>  [<c018decb>] __writeback_single_inode+0x8b/0x470
>>  [<c018e75b>] generic_sync_sb_inodes+0x24b/0x470
>>  [<c018e9a7>] sync_sb_inodes+0x27/0x30
>>  [<c018ec33>] writeback_inodes+0xb3/0xe0
>>  [<c01560f2>] wb_kupdate+0x82/0xf0
>>  [<c015660b>] pdflush+0xeb/0x1b0
>>  [<c0132e72>] kthread+0x42/0x70
>>  [<c0104d4b>] kernel_thread_helper+0x7/0x1c
> 
> Do you have any messages before this one? Seems like it is probably
> metadata,
> but we've only caught it at the last minute...

No other messages before that. Bazillion through-nfs stacks after this...

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

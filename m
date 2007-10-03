Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbXJCLEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbXJCLEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbXJCLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:04:16 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:36033 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754267AbXJCLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:04:15 -0400
X-RocketYMMF: knobi.rm
Date: Wed, 3 Oct 2007 04:04:14 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: [PATCH 0/5] sluggish writeback fixes
To: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
In-Reply-To: <391315777.14430@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <7370.7646.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> Andrew,
> 
> The following patches fix the sluggish writeback behavior.
> They are well understood and well tested - but not yet widely tested.
> 
> The first patch reverts the debugging -mm only
> check_dirty_inode_list.patch -
> which is no longer necessary.
> 
> The following 4 patches do the real jobs:
> 
> [PATCH 2/5] writeback: fix time ordering of the per superblock inode
> lists 8
> [PATCH 3/5] writeback: fix ntfs with sb_has_dirty_inodes()
> [PATCH 4/5] writeback: remove pages_skipped accounting in
> __block_write_full_page()
> [PATCH 5/5] writeback: introduce writeback_control.more_io to
> indicate more io
> 
> They share the same goal as the following patches in -mm. Therefore
> I'd
> recommend to put the last 4 new ones after them:
> 
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
> writeback-fix-comment-use-helper-function.patch
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
>
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
> writeback-fix-periodic-superblock-dirty-inode-flushing.patch
> 
> Regards,
> Fengguang
Hi Fenguang,

 now that Peters stuff seems to make it into mainline, do you think
your fixes should go in as well? Would definitely help to broaden the
tester base. Definitely by one very interested tester :-)

Keep on the good work
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de

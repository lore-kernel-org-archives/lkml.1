Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZDTUmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZDTUmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbZDTUm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:42:29 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:33283 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915AbZDTUm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:42:28 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
References: <a4423d670904161223r2e026b6u903137c709318551@mail.gmail.com>
	<49EC8317.9080300@suse.com>
Date: Mon, 20 Apr 2009 13:42:19 -0700
In-Reply-To: <49EC8317.9080300@suse.com> (message from Jeff Mahoney on Mon, 20
	Apr 2009 10:13:43 -0400)
Message-ID: <87vdozcb10.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> writes:

> Alexander Beregalov wrote:
>> Hi Jeff
>> 
>> The kernel prints this message every 20seconds
>> [  836.973100]
>> [  836.983494] REISERFS warning (device sda2): jdm-20004
>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>> [  836.983496]
>> [  894.203634] REISERFS warning (device sda2): jdm-20004
>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>> [  894.203636]
>> [  894.205784] REISERFS warning (device sda2): jdm-20004
>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>> 
>> commit a41f1a4715
>> 
>> CONFIG_REISERFS_FS=y
>> # CONFIG_REISERFS_CHECK is not set
>> # CONFIG_REISERFS_PROC_INFO is not set
>> # CONFIG_REISERFS_FS_XATTR is not set
>> 
>> I did not enable XATTR before,
>> should I enable it now ?
>
> You shouldn't need to, and you shouldn't be seeing those messages.
>
> What are you doing to reproduce it? I disabled the xattr config option,
> copied a directory tree over and removed it. I didn't see anything.

i see the same thing all the time. maybe not as often, but i get
plenty of these warnings. i have the same configuration as the above.
it started with 2.6.30-rc1 for me.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |

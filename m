Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbZCYQqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbZCYQqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZCYQqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:46:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbZCYQqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:46:02 -0400
Message-ID: <49CA60FF.9030602@suse.de>
Date: Thu, 26 Mar 2009 00:51:11 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-03-23-22-34 uploaded (reiserfs)
References: <200903240539.n2O5d6A8018954@imap1.linux-foundation.org> <49C9483B.1030905@oracle.com> <49C9C163.8040502@suse.de> <49CA48A0.6000404@oracle.com>
In-Reply-To: <49CA48A0.6000404@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Randy Dunlap Wrote:
> Coly Li wrote:
>> Hi Randy,
>>
>> Randy Dunlap Wrote:
>>> akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2009-03-23-22-34 has been uploaded to
>>>>
>>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>>
>>>> and will soon be available at
>>>>
>>>>    git://git.zen-sources.org/zen/mmotm.git
>>>>
>>>> It contains the following patches against 2.6.29-rc8:
>>>> fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
>>> fs/built-in.o: In function `reiserfs_statfs':
>>> super.c:(.text+0x7332b): undefined reference to `crc32_le'
>>> super.c:(.text+0x7333f): undefined reference to `crc32_le'
>>>
>> Hmm, it should not be. The v2 patch includes linux/crc32.h, and I tested without
>> any error. Now I am downloading mmotm to verify.
> 
> CONFIG_CRC32=m
> 
> Since reiserfs is built into the kernel image (CONFIG_REISERFS=y),
> CONFIG_CRC32 also needs to be =y.
> Probably just add
> 	select CRC32
> 	select BITREVERSE
> to the REISERFS_FS kconfig entry.
> 
Oh, I thought of that, yeah, I will send another patch for the fix.
Thanks for pointing out this :)

>> BTW, from series file of mmotm, I see two version patches,
>> fs-reiserfs-return-f_fsid-for-statfs2.patch
>> fs-reiserfs-return-f_fsid-for-statfs2-v2.patch
>> are all included. I suspect whether this is a proper behavior.
> 
> The v2 patch mostly replaces the first one.  I don't see a
> problem with them.
> 
Interesting, don't know how it works so well ;))


-- 
Coly Li
SuSE Labs

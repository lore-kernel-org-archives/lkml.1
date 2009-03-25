Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbZCYRRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbZCYRRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZCYRRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:17:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:50809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbZCYRRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:17:23 -0400
Message-ID: <49CA6856.9090005@suse.de>
Date: Thu, 26 Mar 2009 01:22:30 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: select CRC32 and BITREVERSE for REISERFS_FS
 Kconfig entry
References: <49CA629E.7040701@suse.de> <49CA64BE.2090804@oracle.com>
In-Reply-To: <49CA64BE.2090804@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Randy Dunlap Wrote:
> Coly Li wrote:
>> In patch fs-reiserfs-return-f_fsid-for-statfs2-v2.patch (from mmotm), crc32_le()
>> is referenced. If reiserfs is compiled into kernel and crc32_le() is compiled as
>> kernel module, there might be a compiling error as:
>>     fs/built-in.o: In function `reiserfs_statfs':
>>     super.c:(.text+0x7332b): undefined reference to `crc32_le'
>>     super.c:(.text+0x7333f): undefined reference to `crc32_le'
>> This patch select CRC32 and BITREVERSE for REISERFS_FS Kconfig entry, which
>> indicates compiling crc32_le() into kernel.
>>
>> Thanks to Randy Dunlap for pointing out this error and providing helpful solution.
>>
>> Signed-off-by: Coly Li <coly.li@suse.de>
>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Hi Randy,

You give me an important enlightenment, for my return-f_fsid-for-statfs2 patch
serial, selecting CRC32 and BITREVERSE is necessary ...

Andrew,

I will check it and send out fix ASAP.

Thanks.

-- 
Coly Li
SuSE Labs

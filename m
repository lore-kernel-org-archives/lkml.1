Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYLSFte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYLSFte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYLSFtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:49:19 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:33738 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYLSFtS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:49:18 -0500
Date: Fri, 19 Dec 2008 08:49:10 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <1626525439.20081219084910@emcraft.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: paulus@samba.org, wd@denx.de, dzu@denx.de, linux-kernel@vger.kernel.org,
       <miltonm@bga.com>, <linuxppc-dev@ozlabs.org>, <viro@zeniv.linux.org.uk>,
       <Geert.Uytterhoeven@sonycom.com>, <yanok@emcraft.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re[2]: [PATCH][v2] fork_init: fix division by zero
In-Reply-To: <20081218144553.91226f50.akpm@linux-foundation.org>
References: <200812101950.51958.yur@emcraft.com> <20081211121635.ff58193f.akpm@linux-foundation.org> <18753.46301.944770.779390@cargo.ozlabs.ibm.com> <200812181047.50332.yur@emcraft.com> <20081218144553.91226f50.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Andrew,

On Friday, December 19, 2008 you wrote:
[snip]
>>  There is one more warning from the common code when I use 256KB pages:
>> 
>>    CC      mm/shmem.o
>> mm/shmem.c: In function 'shmem_truncate_range':
>> mm/shmem.c:613: warning: division by zero
>> mm/shmem.c:619: warning: division by zero
>> mm/shmem.c:644: warning: division by zero
>> mm/shmem.c: In function 'shmem_unuse_inode':
>> mm/shmem.c:873: warning: division by zero
>> 
>>  The problem here is that ENTRIES_PER_PAGEPAGE becomes 0x1.0000.0000
>> when PAGE_SIZE is 256K.
>> 
>>  How about the following fix ?

[snip]

> Looks sane.

 Thanks for reviewing.

> But to apply this I'd prefer a changelog, a signoff and a grunt from Hugh.

 Sure, I'll post this in the separate thread then; keeping Hugh in CC.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com


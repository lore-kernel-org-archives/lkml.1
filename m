Return-Path: <linux-kernel-owner+w=401wt.eu-S935384AbZDJUF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935384AbZDJUF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZDJUFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:05:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:50745 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbZDJUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:05:07 -0400
Message-ID: <49DFA64E.6040800@oracle.com>
Date: Fri, 10 Apr 2009 13:04:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: Re: mmotm 2009-04-10-02-21 uploaded (shmem)
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>	<49DFA3B3.3080003@oracle.com> <20090410130009.caf2285b.akpm@linux-foundation.org>
In-Reply-To: <20090410130009.caf2285b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49DFA638.01A1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Apr 2009 12:53:23 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-04-10-02-21 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>>
>>> It contains the following patches against 2.6.30-rc1:
>>
>> I get a few of these build errors, but I don't see why.
>> (config attached)
>>
>>
>> mm/shmem.c: In function 'shmem_file_setup':
>> mm/shmem.c:2622: error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)
> 
> Thanks.
> 
> --- a/mm/shmem.c~shmem-respect-max_lfs_filesize-fix
> +++ a/mm/shmem.c
> @@ -24,6 +24,7 @@
>  #include <linux/init.h>
>  #include <linux/vfs.h>
>  #include <linux/mount.h>
> +#include <linux/pagemap.h>
>  #include <linux/file.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>

Just move that #include up from under the #ifdef CONFIG_SHMEM then.


-- 
~Randy

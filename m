Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZLDEAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZLDEAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 23:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZLDEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 23:00:12 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60161 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbZLDEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 23:00:11 -0500
Message-ID: <4B1888CE.8000406@ct.jp.nec.com>
Date: Fri, 04 Dec 2009 12:58:06 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp,
       swhiteho@redhat.com, tytso@mit.edu
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
References: <200912032240.nB3Mevae027408@imap1.linux-foundation.org> <20091204021444.GA8392@x200>
In-Reply-To: <20091204021444.GA8392@x200>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
>> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
>> +++ a/include/linux/sched.h
>> @@ -1452,8 +1452,10 @@ struct task_struct {
>>  	gfp_t lockdep_reclaim_gfp;
>>  #endif
>>  
>> +#ifdef CONFIG_FS_JOURNAL_INFO
>>  /* journalling filesystem info */
>>  	void *journal_info;
>> +#endif
> 
> This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.

I'm sorry, I'm not sure what you're mentioning.

Thanks,
Hiroshi

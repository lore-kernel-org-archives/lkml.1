Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYKXRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYKXRGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYKXRGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:06:00 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:41224 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYKXRF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:05:59 -0500
Message-ID: <492AE09A.7070204@suse.de>
Date: Tue, 25 Nov 2008 01:12:58 +0800
From: Coly Li <coyli@suse.de>
Reply-To: coyli@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix similar typos to successfull
References: <492A9EFF.5050301@suse.de> <492AD564.9040300@oracle.com>
In-Reply-To: <492AD564.9040300@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Randy Dunlap Wrote:
> Coly Li wrote:
>> When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
>> in kernel tree, 22 typos found totally --  great minds always think alike :)
>>
>> This patch fixes all the similar typos.
>>
>> Singed-off-by: Coly Li <coyli@suse.de>
>> ---
>>  Documentation/hwmon/abituguru-datasheet   |    4 ++--
>>  Documentation/scsi/scsi_fc_transport.txt  |    4 ++--
>>  arch/powerpc/platforms/cell/spufs/spufs.h |    2 +-
>>  drivers/infiniband/hw/nes/nes_cm.c        |    2 +-
>>  drivers/isdn/hardware/eicon/debuglib.h    |    2 +-
>>  drivers/isdn/hardware/eicon/os_4bri.c     |    2 +-
>>  drivers/isdn/hardware/eicon/os_bri.c      |    2 +-
>>  drivers/isdn/hardware/eicon/os_pri.c      |    2 +-
>>  drivers/mtd/ubi/kapi.c                    |    2 +-
>>  drivers/net/wireless/ath5k/dma.c          |    2 +-
>>  drivers/net/wireless/zd1211rw/zd_mac.c    |    2 +-
>>  drivers/s390/block/dasd_3990_erp.c        |    2 +-
>>  drivers/s390/block/dasd_int.h             |    2 +-
>>  drivers/s390/char/tape_3590.c             |    2 +-
>>  drivers/s390/cio/cio.c                    |    2 +-
>>  drivers/s390/cio/qdio_main.c              |    2 +-
>>  fs/ext4/extents.c                         |    2 +-
>>  fs/ocfs2/dlmglue.c                        |    4 ++--
>>  net/sctp/auth.c                           |    2 +-
>>  19 files changed, 22 insertions(+), 22 deletions(-)
> 
> Ack all <deleted> patches.  However, I don't think that the
> one below needs to use -ly.  Just change to "successful" IMO,
> as in:  Log this successful return from ocfs2_dlm_lock
> 
So "return" here is noun, not verb ?

Thanks for ack :)
> Thanks.
> 
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index ec68442..d0cd0e1 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -1290,7 +1290,7 @@ again:
>>  			goto out;
>>  		}
>>
>> -		mlog(0, "lock %s, successfull return from ocfs2_dlm_lock\n",
>> +		mlog(0, "lock %s, successfully return from ocfs2_dlm_lock\n",
>>  		     lockres->l_name);
>>
>>  		/* At this point we've gone inside the dlm and need to
>> @@ -2923,7 +2923,7 @@ static int ocfs2_drop_lock(struct ocfs2_super *osb,
>>  		ocfs2_dlm_dump_lksb(&lockres->l_lksb);
>>  		BUG();
>>  	}
>> -	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
>> +	mlog(0, "lock %s, successfully return from ocfs2_dlm_unlock\n",
>>  	     lockres->l_name);
>>
>>  	ocfs2_wait_on_busy_lock(lockres);

-- 
Coly Li
SuSE PRC Labs

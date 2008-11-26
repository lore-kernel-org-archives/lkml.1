Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYKZIlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYKZIlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYKZIlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:41:13 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:45759 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYKZIlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:41:11 -0500
Message-ID: <492D0D4E.1040609@suse.de>
Date: Wed, 26 Nov 2008 16:48:14 +0800
From: Coly Li <coyli@suse.de>
Reply-To: coyli@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix similar typos to successfull, v2
References: <492AE7ED.8040304@suse.de> <20081125145308.8633bf4a.akpm@linux-foundation.org>
In-Reply-To: <20081125145308.8633bf4a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton Wrote:
> On Tue, 25 Nov 2008 01:44:13 +0800
> Coly Li <coyli@suse.de> wrote:
> 
>> When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
>> in kernel tree, 22 typos found totally --  great minds always think alike  :)
> 
> Mutter.  I have a super-strict (lol) policy of "I don't take patches
> which fix typos/spellos in comments", because we have so many such
> errors, and I'd get buried in silly patches.  But I do take patches
> which fix documentation and user-visible printks, etc.
> 
The first time I know this policy, remember it now ;)

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
> 
> This patch sneakily mixed the two up, so I merged it ;)
grep does not understand difference between code and comments ;)
I am not 100% agreed that leaving typos/spellos in comments is a proper policy. Anyway, thanks for
the effort to merge this patch, it's impossible for me to put so many maintainers into Cc list :)

-- 
Coly Li
SuSE PRC Labs

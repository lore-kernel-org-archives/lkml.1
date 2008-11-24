Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYKXRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYKXRQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYKXRQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:16:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:21605 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbYKXRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dGaP1oT840152UzmXdVV6/T0WVAwaeGqWEkMBdJZNOB2lnQO5KZi2SWEWd/U47KVL0
         uABla48dfmp6+x+uNBuP3zDRR6DmuIo0PJGHDSzOnC1Bli+KRB3+0E4wTDsO7jMdsw3O
         S4t276h54haze6e0ghlWtqTdlu9mpscF67MXc=
Date: Mon, 24 Nov 2008 17:16:23 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Coly Li <coyli@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix similar typos to successfull
Message-ID: <20081124171623.GA25325@hack.voiplan.pt>
References: <492A9EFF.5050301@suse.de> <492AD564.9040300@oracle.com> <492AE09A.7070204@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492AE09A.7070204@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 01:12:58AM +0800, Coly Li wrote:
>
>
>Randy Dunlap Wrote:
>> Coly Li wrote:
>>> When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
>>> in kernel tree, 22 typos found totally --  great minds always think alike :)
>>>
>>> This patch fixes all the similar typos.
>>>
>>> Singed-off-by: Coly Li <coyli@suse.de>
>>> ---
>>>  Documentation/hwmon/abituguru-datasheet   |    4 ++--
>>>  Documentation/scsi/scsi_fc_transport.txt  |    4 ++--
>>>  arch/powerpc/platforms/cell/spufs/spufs.h |    2 +-
>>>  drivers/infiniband/hw/nes/nes_cm.c        |    2 +-
>>>  drivers/isdn/hardware/eicon/debuglib.h    |    2 +-
>>>  drivers/isdn/hardware/eicon/os_4bri.c     |    2 +-
>>>  drivers/isdn/hardware/eicon/os_bri.c      |    2 +-
>>>  drivers/isdn/hardware/eicon/os_pri.c      |    2 +-
>>>  drivers/mtd/ubi/kapi.c                    |    2 +-
>>>  drivers/net/wireless/ath5k/dma.c          |    2 +-
>>>  drivers/net/wireless/zd1211rw/zd_mac.c    |    2 +-
>>>  drivers/s390/block/dasd_3990_erp.c        |    2 +-
>>>  drivers/s390/block/dasd_int.h             |    2 +-
>>>  drivers/s390/char/tape_3590.c             |    2 +-
>>>  drivers/s390/cio/cio.c                    |    2 +-
>>>  drivers/s390/cio/qdio_main.c              |    2 +-
>>>  fs/ext4/extents.c                         |    2 +-
>>>  fs/ocfs2/dlmglue.c                        |    4 ++--
>>>  net/sctp/auth.c                           |    2 +-
>>>  19 files changed, 22 insertions(+), 22 deletions(-)
>> 
>> Ack all <deleted> patches.  However, I don't think that the
>> one below needs to use -ly.  Just change to "successful" IMO,
>> as in:  Log this successful return from ocfs2_dlm_lock
>> 
>So "return" here is noun, not verb ?


Here, yes. Becuase if it's a verb, it will be "returns successfully
from ... ". See the order? :)


-- 
"Sometimes the only way to stay sane is to go a little crazy."


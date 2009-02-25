Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbZBYPs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbZBYPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZBYPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:48:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZBYPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:48:16 -0500
Date: Wed, 25 Feb 2009 15:48:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch][rfc] fs: move bdev code out of buffer.c
Message-ID: <20090225154810.GN28946@ZenIV.linux.org.uk>
References: <20090225094419.GF22785@wotan.suse.de> <49A51EFF.4020600@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A51EFF.4020600@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:35:43AM -0500, Jeff Garzik wrote:
> Nick Piggin wrote:
>> Move some block device related code out from buffer.c and put it in
>> block_dev.c. I'm trying to move non-buffer_head code out of buffer.c
>>
>> Is this OK?
>>
>> ---
>>  fs/block_dev.c              |  146 ++++++++++++++++++++++++++++++++++++++++++++
>>  fs/buffer.c                 |  145 -------------------------------------------
>>  include/linux/buffer_head.h |    7 --
>>  include/linux/fs.h          |    7 ++
>>  4 files changed, 153 insertions(+), 152 deletions(-)
>
> If you are going to churn all this old code, maybe the blkdev stuff better 
> belongs in block/ dir?

Some of it...  BTW, so does fs/partitions/* stuff.  I'll resurrect the
patch taking that crap over to block/*.

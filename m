Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZCDKQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZCDKQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZCDKQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:16:43 -0500
Received: from brick.kernel.dk ([93.163.65.50]:59351 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZCDKQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:16:43 -0500
Date: Wed, 4 Mar 2009 11:16:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kris Shannon <kris@shannon.id.au>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] Fix kernel NULL pointer dereference in xen-blkfront
Message-ID: <20090304101640.GY11787@kernel.dk>
References: <e51f4f550903020047m7f110039v48bcac6a345f1fd6@mail.gmail.com> <49ADA82A.6080508@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ADA82A.6080508@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03 2009, Jeremy Fitzhardinge wrote:
> Kris Shannon wrote:
>> When booting Xen Dom0 on a pre-release 3.2.1 hypervisor the system Oopses on a
>> "Unable to handle kernel NULL pointer dereference" in xenwatch.
>>
>> From the backtrace it looks like backend_changed is calling bdget_disk
>> with a NULL pointer.  Checking for NULL and returning ENODEV instead
>> allows the kernel to boot.
>>   
>
> Thanks, applied.  (BTW, please cc: me and xen-devel for Xen-related  
> reports.)
>
> Jens: could you pull this; I think this is probably -rc material.  This  
> crash just started happening, so I guess its a side-effect of some core  
> kernel change.
>
> The following changes since commit c7241227f61ca6606a7fa3555391360d92bd8d9b:
>  Jens Axboe (1):
>        xen/blkfront: use blk_rq_map_sg to generate ring entries
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/frontend/blkfront
>
> Kris Shannon (1):
>      Fix kernel NULL pointer dereference in xen-blkfront
>
> drivers/block/xen-blkfront.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)

Sure, pulled.

-- 
Jens Axboe


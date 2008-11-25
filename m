Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYKYWx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYKYWx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKYWxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:53:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbYKYWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:53:47 -0500
Date: Tue, 25 Nov 2008 14:53:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Coly Li <coyli@suse.de>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH] fix similar typos to successfull, v2
Message-Id: <20081125145308.8633bf4a.akpm@linux-foundation.org>
In-Reply-To: <492AE7ED.8040304@suse.de>
References: <492AE7ED.8040304@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 01:44:13 +0800
Coly Li <coyli@suse.de> wrote:

> When I review ocfs2 code, find there are 2 typos to "successfull". After doing grep "successfull "
> in kernel tree, 22 typos found totally --  great minds always think alike  :)

Mutter.  I have a super-strict (lol) policy of "I don't take patches
which fix typos/spellos in comments", because we have so many such
errors, and I'd get buried in silly patches.  But I do take patches
which fix documentation and user-visible printks, etc.

>  Documentation/hwmon/abituguru-datasheet   |    4 ++--
>  Documentation/scsi/scsi_fc_transport.txt  |    4 ++--
>  arch/powerpc/platforms/cell/spufs/spufs.h |    2 +-
>  drivers/infiniband/hw/nes/nes_cm.c        |    2 +-
>  drivers/isdn/hardware/eicon/debuglib.h    |    2 +-
>  drivers/isdn/hardware/eicon/os_4bri.c     |    2 +-
>  drivers/isdn/hardware/eicon/os_bri.c      |    2 +-
>  drivers/isdn/hardware/eicon/os_pri.c      |    2 +-
>  drivers/mtd/ubi/kapi.c                    |    2 +-
>  drivers/net/wireless/ath5k/dma.c          |    2 +-
>  drivers/net/wireless/zd1211rw/zd_mac.c    |    2 +-
>  drivers/s390/block/dasd_3990_erp.c        |    2 +-
>  drivers/s390/block/dasd_int.h             |    2 +-
>  drivers/s390/char/tape_3590.c             |    2 +-
>  drivers/s390/cio/cio.c                    |    2 +-
>  drivers/s390/cio/qdio_main.c              |    2 +-
>  fs/ext4/extents.c                         |    2 +-
>  fs/ocfs2/dlmglue.c                        |    4 ++--
>  net/sctp/auth.c                           |    2 +-

This patch sneakily mixed the two up, so I merged it ;)

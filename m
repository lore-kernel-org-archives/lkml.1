Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZHTNCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZHTNCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZHTNCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:02:31 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:37824 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZHTNCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:02:31 -0400
Subject: Re: mount.nfs: access denied by server
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-nfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090820071315.GA14765@localhost>
References: <20090820071315.GA14765@localhost>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 09:02:29 -0400
Message-Id: <1250773349.5352.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 1121 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: C495B69CC4BDD24077C356BC0A2B1208EB83B00C
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 152 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:13 +0800, Wu Fengguang wrote:
> Hi,
> 
> After upgrading NFS client kernel to latest linux-next, NFS mount
> failed:
> 
>         # mount -t nfs pxe:/cc /cc
>         mount.nfs: access denied by server while mounting pxe:/cc
> 
>         # uname -a
>         Linux hp 2.6.31-rc6-next-20090818 #61 SMP Thu Aug 20 14:46:10 CST 2009 x86_64 GNU/Linux 
> 
> However server log says OK:
> 
>         Aug 20 15:02:09 wu-t61 mountd[4599]: authenticated mount request from 192.168.11.6:973 for /cc (/cc)
>         Aug 20 15:02:09 wu-t61 mountd[4599]: authenticated unmount request from 192.168.11.6:974 for /cc (/cc)
> 
> However-2: nfsroot can be mounted at boot time. Server kernel has always been 2.6.30.
> 
> Any ideas?
> 
> Thanks,
> Fengguang

Can you try again after enabling mount debugging on the NFS client?

echo 512 > /proc/sys/sunrpc/nfs_debug


Cheers
  Trond


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbXFDHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbXFDHqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXFDHqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 03:46:30 -0400
Received: from 64-142-28-230.dsl.static.sonic.net ([64.142.28.230]:57298 "EHLO
	Angel.zoy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbXFDHq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 03:46:29 -0400
X-Greylist: delayed 1368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 03:46:29 EDT
Date: Mon, 4 Jun 2007 00:23:40 -0700
From: Michel Lespinasse <walken@zoy.org>
To: linux-kernel@vger.kernel.org
Cc: trond.myklebust@fys.uio.no
Subject: nfsroot and locking
Message-ID: <20070604072340.GC3315@zoy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a quick question about nfsroot in linux: Is there any way to
use nfsv3 in the nfsroot (nolock is OK there), and then mount other
directories with locking enabled ?

The default nfs options when using nfsroot are to use nfsv2 without locking.
After booting, one can mount other filesystems which will default to
nfsv3 with locking.

By passing extra options in the nfsroot parameter, one can boot with nfs3
if desired. For example v3,tcp,rsize=131072,wsize=131072,intr set the
same options in nfsroot than would otherwise be the after-boot default,
except that locking stays disabled (I understand lockd can not be started
as portmap is not running during boot).

However after starting the nfsroot with nfsv3, I am unable to mount any
other shares with locking. Passing the 'lock' option to mount will add
'lock' in /etc/mtab, but /proc/mounts will still show the share with 'nolock'
and rpcinfo shows that lockd was not started.

Is there a reason for this, or an easy workaround ?

for reference, I'm currently running debian etch with a 2.6.20.12 kernel.
Also I'd appreciate to be copied on replies as I'm not on the list.

Thanks,

-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller

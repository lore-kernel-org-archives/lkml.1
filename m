Return-Path: <linux-kernel-owner+w=401wt.eu-S1946065AbXBPR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946065AbXBPR7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946072AbXBPR7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:59:18 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:42623 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946065AbXBPR7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:59:17 -0500
Date: Sat, 17 Feb 2007 04:58:51 +1100
From: David Chinner <dgc@sgi.com>
To: Ahmed El Zein <a.elzein@gawab.net>
Cc: David Chinner <dgc@sgi.com>, "Ramy M. Hassan " <ramy@gawab.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs internal error on a new filesystem
Message-ID: <20070216175851.GI5724@melbourne.sgi.com>
References: <20070215161932.3230.qmail@info11.gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215161932.3230.qmail@info11.gawab.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 04:19:32PM +0000, Ahmed El Zein wrote:
> David Chinner <dgc@sgi.com> wrote on 15 Feb 2007, 11:16 AM:
> >What is your filessytem layout? (xfs_info <mntpt>) How much memory
> >do you have and were you near enomem conditions?
> 
> We have 1536 MB of ram. It is possible that at the time of the crash we
> were near enomem conditions, I don;t know for sure but we have seen such
> spikes on our servers.

Ok, so that's a possibility.

> root@info6:~# xfs_info /vol/6/
> meta-data=/dev/sdd8              isize=256    agcount=16, agsize=7001584
> blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=112025248, imaxpct=25
>          =                       sunit=16     swidth=64 blks, unwritten=0
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0

Nothing unusual here...

> >Yes. Do you have ECC memory on your server? Have you run memtest86?
> >Were there any I/O errors in the log prior to the shutdown message?
> Yes, we have ECC memory.
> We will try to run memtest86 as soon as possible.
> There were no I/O errors in the log prior to the shutdown message.
> 
> Btw, this is a vmware image. /vol/6 is an exported physical partition.

I'd suggest trying to reproduce this problem without vmware in the
picture - you need to rule out a vmware based problem first before we
can really make any progress on this....

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

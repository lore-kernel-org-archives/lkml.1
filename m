Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662Ab0AAJ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0AAJ35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 04:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236Ab0AAJ34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 04:29:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43123 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0AAJ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 04:29:54 -0500
Date: Fri, 1 Jan 2010 10:29:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] reiserfs lock inversion fixes on xattr
Message-ID: <20100101092944.GB12203@elte.hu>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
 <1262205747-9208-1-git-send-regression-fweisbec@gmail.com>
 <alpine.DEB.2.01.0912301943020.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912301943020.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 3.4
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.4 required=5.9 tests=FH_DATE_PAST_20XX autolearn=no SpamAssassin version=3.2.5
	3.4 FH_DATE_PAST_20XX      The date is grossly in the future.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Kujau <lists@nerdbynature.de> wrote:

> On Wed, 30 Dec 2009 at 21:42, Frederic Weisbecker wrote:
> > I hope you can give it a try (and/or review) before I send the whole
> > to Linus.
> 
> Without your patches, "dbench -x" was pretty much instantly causing the 
> threads to lock up, forcing me to reboot the box. With LOCKDEP enabled, 
> warnings were printed. After applying your patches (and a reboot) I've run 
> "dbench -x" for quite a while now with different runtimes and number of
> clients and it's not locking up any more. I've tested with:
> 
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> # CONFIG_REISERFS_FS_SECURITY is not set
> 
> ...and a few "Kernel hacking" options set. Full config and dmesg:
> 
>    http://nerdbynature.de/bits/2.6.33-rc1/reiserfs/t3/
> 
>    (although I'm not really testing -rc1 but latest mainline -git
>     and your changes pulled)
> 
> So, feel free to add:
> 
>   Tested-by: Christian Kujau <lists@nerdbynature.de>

Frederic, i'd suggest you send this tree to Linus with Christian's tested-by 
tags added ASAP - we better have these fixes in -rc3.

Thanks,

	Ingo

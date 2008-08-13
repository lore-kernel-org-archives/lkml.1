Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYHMPZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYHMPZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYHMPZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:25:01 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32305 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbYHMPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:25:00 -0400
Date: Wed, 13 Aug 2008 08:25:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: free_beer_for_all@yahoo.com
Cc: linux-kernel@vger.kernel.org, dushistov@mail.ru
Subject: Re: Proposal: kernel config option for default UFS filesystem
Message-Id: <20080813082510.044e029c.randy.dunlap@oracle.com>
In-Reply-To: <618349.28606.qm@web46105.mail.sp1.yahoo.com>
References: <618349.28606.qm@web46105.mail.sp1.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 02:37:07 -0700 (PDT) barry bouwsma wrote:

[cc-ing UFS maintainer]

> Servus, Sportsfreunde!
> 
> I'm sharing my x86 machine with several flavours of BSDen, and
> thereby wishing to mount the UFS filesystems under Linux.
> 
> Normally one has to specify the filesystem type, lest it otherwise
> default to `old', which is for me, not useful.  In my case, a 44bsd
> default would match all my filesystems used by NetBSD and FreeBSD.
> 
> I've recently been running with a hack to Kconfig, which lets me
> select at config time, whether I wish to default to a different
> ufstype.  For me, with oldconfig, it spits out something like...
> 
> UFS file system support (read only) (UFS_FS) [M/n/y/?] m
>   UFS file system write support (DANGEROUS) (UFS_FS_WRITE) [Y/n/?] y
>   UFS debugging (UFS_DEBUG) [N/y/?] n
> Default UFS filesystem type
> > 1. Old default (UFS_UFSTYPE_OLD)
>   2. Sun x86 (UFS_UFSTYPE_SUNx86)
>   3. Sun (UFS_UFSTYPE_SUN)
>   4. SunOS (UFS_UFSTYPE_SUNOS)
>   5. 44BSD (Free-, Net-, OpenBSD and friends) (UFS_UFSTYPE_44BSD) (NEW)
>   6. UFS2 as added to 44BSD systems (UFS_UFSTYPE_UFS2)
>   7. HP (UFS_UFSTYPE_HP)
>   8. NeXTStep CD (UFS_UFSTYPE_NEXTSTEP_CD)
>   9. NeXTStep (UFS_UFSTYPE_NEXTSTEP)
>   10. OpenStep (UFS_UFSTYPE_OPENSTEP)
> choice[1-10?]: 5
> 
> Is this something worthy of further cluttering up the kernel config
> for my convenience, or not, given that there is no way presently to
> automagically determine the proper UFS filesystem type at mount?
> 
> 
> If it is, I'll post my hacks for ridicule and derision.

I'd say Yes, it's useful.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

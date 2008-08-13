Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYHMJhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYHMJhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYHMJhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:37:10 -0400
Received: from n79.bullet.mail.sp1.yahoo.com ([98.136.44.39]:48207 "HELO
	n79.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751809AbYHMJhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:37:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 823786.27655.bm@omp404.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=TRaivWtiv6/KzaYotkOswQzW6mqcPtql3Xn461LQIfz9MPOqE3wNvsD5kTsWwQvhYmWD8anEx9eKkUwvIOmcT51QAc60U8WWuUZNhxZ8S4yWsr9s99k0ELesEc8PeyN/zVQT5E2UR5zSgHBXxXwWjllLGgjXt8ZUaS/LwcPYL3c=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 13 Aug 2008 02:37:07 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: Proposal: kernel config option for default UFS filesystem
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <618349.28606.qm@web46105.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Servus, Sportsfreunde!

I'm sharing my x86 machine with several flavours of BSDen, and
thereby wishing to mount the UFS filesystems under Linux.

Normally one has to specify the filesystem type, lest it otherwise
default to `old', which is for me, not useful.  In my case, a 44bsd
default would match all my filesystems used by NetBSD and FreeBSD.

I've recently been running with a hack to Kconfig, which lets me
select at config time, whether I wish to default to a different
ufstype.  For me, with oldconfig, it spits out something like...

UFS file system support (read only) (UFS_FS) [M/n/y/?] m
  UFS file system write support (DANGEROUS) (UFS_FS_WRITE) [Y/n/?] y
  UFS debugging (UFS_DEBUG) [N/y/?] n
Default UFS filesystem type
> 1. Old default (UFS_UFSTYPE_OLD)
  2. Sun x86 (UFS_UFSTYPE_SUNx86)
  3. Sun (UFS_UFSTYPE_SUN)
  4. SunOS (UFS_UFSTYPE_SUNOS)
  5. 44BSD (Free-, Net-, OpenBSD and friends) (UFS_UFSTYPE_44BSD) (NEW)
  6. UFS2 as added to 44BSD systems (UFS_UFSTYPE_UFS2)
  7. HP (UFS_UFSTYPE_HP)
  8. NeXTStep CD (UFS_UFSTYPE_NEXTSTEP_CD)
  9. NeXTStep (UFS_UFSTYPE_NEXTSTEP)
  10. OpenStep (UFS_UFSTYPE_OPENSTEP)
choice[1-10?]: 5

Is this something worthy of further cluttering up the kernel config
for my convenience, or not, given that there is no way presently to
automagically determine the proper UFS filesystem type at mount?


If it is, I'll post my hacks for ridicule and derision.


thanks,
barry bouwsma


      


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYDFWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYDFWBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYDFWBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:01:00 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1945 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYDFWA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:00:59 -0400
Subject: Re: [PATCH] drivers/ata/sata_via.c - Eliminate "may be used
	uninitialized" warning
From: Joe Perches <joe@perches.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080406215054.GI30987@cs181133002.pp.htv.fi>
References: <1207518320.1803.52.camel@localhost>
	 <20080406215054.GI30987@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Apr 2008 15:00:07 -0700
Message-Id: <1207519207.1803.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 00:50 +0300, Adrian Bunk wrote:
> On Sun, Apr 06, 2008 at 02:45:20PM -0700, Joe Perches wrote:
> > Called by svia_init_one with a temporary,
> > so there's no effective code change.
> I'm not getting any warning here.
> Are you using an older gcc?

Yes.  Slightly less than 4.3.0

$ gcc --version
gcc (GCC) 4.2.2 20071128 (prerelease) (4.2.2-3.1mdv2008.0)

$ git-show
commit 6fdf5e67fe8d3c83500dad9acae985132c2459a3
Merge: abd24df... e64a3cf...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Apr 4 15:09:44 2008 -0700

    Merge branch 'upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/ralf/upstream-linus
    
    * 'upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/ralf/upstream-linus:
      [MIPS] Make KGDB compile on UP
      [MIPS] Pb1200: Fix header breakage

$ make defconfig
[]
$ make clean
[]
$ make drivers/ata/sata_via.o
[]
  CC      drivers/ata/sata_via.o
drivers/ata/sata_via.c: In function ‘svia_init_one’:
drivers/ata/sata_via.c:504: warning: ‘host’ may be used uninitialized in this function



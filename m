Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZDVMts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZDVMts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZDVMti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:49:38 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:54089
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbZDVMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:49:37 -0400
Date: Wed, 22 Apr 2009 14:49:32 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: catalin.marinas@arm.com, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 22: kmemleak: unreferenced object
Message-ID: <20090422124932.GA26289@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	catalin.marinas@arm.com, Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090422154247.dbffd285.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422154247.dbffd285.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shortly after booting next-20090422 on an ep9301, kmemleak complains
about an unreferenced object:

kmemleak: unreferenced object 0xc5408610 (size 5):
  comm "swapper", pid 0, jiffies 4294937323
  backtrace:
    [<c00267e0>] save_stack_trace+0x24/0x28
    [<c00a3db4>] kmemleak_alloc+0x144/0x2cc
    [<c00a211c>] __kmalloc_node+0x1bc/0x1d4
    [<c008d730>] kstrdup+0x3c/0x54
    [<c00bedec>] alloc_vfsmnt+0x9c/0x148
    [<c00a7c10>] vfs_kern_mount+0x34/0xa8
    [<c00a7ca4>] kern_mount_data+0x20/0x24
    [<c0013428>] bdev_cache_init+0x54/0xa0
    [<c0012c74>] vfs_caches_init+0x104/0x140
    [<c0008980>] start_kernel+0x244/0x2b8
    [<00008034>] 0x8034
    [<ffffffff>] 0xffffffff

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

      In itself, homosexuality is as limiting as heterosexuality: the
     ideal should be to be capable of loving a woman or a man; either,
      a human being, without  feeling fear, restraint, or obligation
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

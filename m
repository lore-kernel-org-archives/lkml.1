Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYGAUeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYGAUeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYGAUeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:34:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbYGAUee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:34:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: inux-next: Tree for July 1
Date: Tue, 1 Jul 2008 22:36:18 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org, linux-nfs@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
In-Reply-To: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012236.19400.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080630:
> 
> New tree: ttydev - unfortunately it had to be reverted because of build
> failures after lots of conflict resolution (which may have caused the
> build failures).
> 
> Changed tree: the cris tree changed branch names.
> 
> The sched tree gained a couple of conflicts against the ftrace and
> cpus4096 trees.
> 
> The pci tree gained a conflict against the x86 tree.
> 
> The usb tree reverted due to a build failure after merging with the pci
> tree was changed for a fixup patch.
> 
> The v4l-dvb tree lost its three conflicts against Linus' tree.
> 
> The s390 tree gained a conflict against the diver-core tree.
> 
> The ide tree fixed its build problems.
> 
> The nfsd tree lost a conflict against the nfs tree.
> 
> The powerpc tree gained a conflict against the ide tree.
> 
> The net tree gained two conflicts against the powerpc tree.
> 
> The galak tree lost its conflict against the net tree.
> 
> the blk-removal tree gained a conflict against the s390 tree.
> 
> The firmware tree lost several conflicts against the net tree so didn't
> need a commit reverted any more.
> 
> Merging the ttydev tree got several conflicts against the usb and
> firmware trees.  Unfortunately, it also would not build and so was
> reverted.
> 
> I have also applied the following patches for know problems:
> 	module: fix NULL pointer dereference in find_symbol()

I can't mount NFS shares with this kernel.  I get something of this sort in
dmesg and it seems to be 100% reproducible:

[  314.058858] RPC: Registered udp transport module.
[  314.058863] RPC: Registered tcp transport module.
[  314.490970] RPC: transport (0) not supported
[  319.246987] __ratelimit: 23 messages suppressed

linux-next from yesterday was fine with the same .config .

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZIQLH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZIQLH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZIQLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:07:28 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:53970 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZIQLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:07:27 -0400
Message-ID: <4AB21868.2010302@petalogix.com>
Date: Thu, 17 Sep 2009 13:07:20 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 17
References: <20090917172243.67a80fe0.sfr@canb.auug.org.au>
In-Reply-To: <20090917172243.67a80fe0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add code destined for 2.6.33 into linux-next trees until
> (at least) 2.6.32-rc1 is out.  This will hopefully give those who have
> stuff destined for just after -rc1 a chance.
> 
> Changes since 20090916:
> 
> Changed trees: blackfin (new tree from new contact)
> 	ia64 (maintainer back from vacation)
> 
> Removed tree: reiserfs-bkl (temporarily, by request)
> 
> We are seeing conflicts move from one tree to another as Linus merges
> them.
> 
> The tty.current tree gained a conflict against the net-current tree.
> 
> The input-current tree gained a build failure so I sued the version from
> next-20090916.
> 
> the thumb-2 tree lost its conflict.
> 
> The blackfin tree gained a conflict against Linus' tree.
> 
> The ia64 tree gained a conflict against Linus' tree.
> 
> The microblaze tree lost its conflict.

Yes, because I removed that conficts patches.

Thanks,
Michal

> 
> The sh tree lost its conflict.
> 
> The ext4 tree gained a conflict against Linus' tree.
> 
> The pci tree lost its conflict and merge fix.
> 
> The rr tree still has a build failure so I used the version from
> next-20090908.
> 
> The driver-core tree lost a conflict and passed 2 others to other trees.
> 
> The nfsd tree gained a build failure for which I applied a patch.
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> We are up to 140 trees (counting Linus' and 21 trees of patches pending for
> Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Jan Dittmer for adding the linux-next tree to his build tests
> at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
> Dunlap for doing many randconfig builds.
> 
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
> 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZLDJor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZLDJor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZLDJoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:44:46 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40137 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbZLDJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:44:45 -0500
Message-ID: <4B18D9FC.4020801@petalogix.com>
Date: Fri, 04 Dec 2009 10:44:28 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 4
References: <20091204203014.e8ee54ca.sfr@canb.auug.org.au>
In-Reply-To: <20091204203014.e8ee54ca.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091203:
> 
> The ext3 tree lost its build failure.
> 
> The nfs tree gained a build failure so I used the version from
> next-20091203.
> 
> The block tree gained a build failure so I used the version from
> next-20091203.
> 
> The pcmcia tree gained a conflict against the net tree.
> 
> The irda tree gained a conflict against the net tree.
> 
> The limits tree gained conflicts against the net and fsnotify trees.
> 
> The tip tree gained a conflict against the limits tree.
> 
> The sysctl tree gained 2 conflicts against the net tree.
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
> We are up to 155 trees (counting Linus' and 22 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
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


 > Merging microblaze/next
 > CONFLICT (content): Merge conflict in drivers/serial/of_serial.c

I removed that my first patch from my next branch - it is in tty tree.

Michal


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

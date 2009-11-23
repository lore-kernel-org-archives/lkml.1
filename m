Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZKWNEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZKWNEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZKWNEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:04:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:42238 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbZKWNEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:04:04 -0500
Message-ID: <4B0A8841.8090905@petalogix.com>
Date: Mon, 23 Nov 2009 14:04:01 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: linux-next: Tree for November 23
References: <20091123185232.1423c56b.sfr@canb.auug.org.au>
In-Reply-To: <20091123185232.1423c56b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20091120:
> 
> The omap tree lost its conflict.
> 
> The microblaze tree still has a build failure for which I reverted a
> commit.
> 
> The mips tree gained a conflict against the microblaze tree.

It is problem which is caused one my ftrace patch. MIPS ftrace 
implementation was first that's why I should solve it. It is easy to fix.
I just need to know where mips/mips-for-linux-next branch is.

Thanks,
Michal

> 
> The infiniband tree lost its build failure.
> 
> The net tree gained 2 conflicts against the net-current tree.
> 
> The input tree lost its conflict.
> 
> The mfd tree gained 2 build failures - I applied a patch for the first,
> but the second caused me to use the version from next-20091120.
> 
> The alacrity tree lost a conflict.
> 
> The tip tree gained a conflict against the mips tree.
> 
> The staging tree lost a conflict.
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
> We are up to 151 trees (counting Linus' and 22 trees of patches pending for
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

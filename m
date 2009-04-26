Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZDZNU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZDZNU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZDZNUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:20:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45049 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZDZNUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NI50PY/CQ0PbjOMbQ/yOzxXbp5KObeNJ8pw+5FOG0/Ar8yjepIYKUPtYM0TOAIGWDj
         Te0T87oGhExHqQg33+Ib9x4g03F1ADdE6P9suoaFVDE5fOMrnQreRFGX5H9BKGqAHXGk
         9OWtpiIsA7IVdU+UX6b29kzHLw1z+PfK5Ziu8=
Message-ID: <49F45FA4.6020307@panasas.com>
Date: Sun, 26 Apr 2009 16:20:36 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
In-Reply-To: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 24, 2009, 8:04 +0300, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
> 
> I have added a tree that contains only simple build fixes for Linus'
> tree.  It currently contains:
> 
> 	lib: find_next_bit.o needed by a module only, move it from lib to obj

Thanks Stephan!
I've already sent this patch directly to Linus (and while at it,
correcting its subject)
It's committed as a5422a5111811401f7756345e4c237ff06cf6d1e
in Linus' tree.

Benny

> 	powerpc: fix for long standing bug noticed by gcc 4.4.0
> 
> This is just an experiment for now and I am not sure if I should push
> these fixes directly to Linus ...
> 
> Changes since 20090423:
> 
> New tree:
> 	fixes
> 
> The acpi tree gained a build failure for which I reverted a commit.
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
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
> CONFIG_PROFILE_ALL_BRANCHES) and i386, sparc and sparc64 defconfig.
> These builds also have CONFIG_ENABLE_WARN_DEPRECATED,
> CONFIG_ENABLE_MUST_CHECK and CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> We are up to 135 trees (counting Linus' and 18 trees of patches pending for
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765131AbYD0Xr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765131AbYD0Xr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbYD0XrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:47:10 -0400
Received: from slackware.com ([64.57.102.34]:46440 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764765AbYD0XrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:47:09 -0400
X-Greylist: delayed 3813 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 19:47:08 EDT
Message-ID: <48150178.4050900@slackware.com>
Date: Sun, 27 Apr 2008 17:43:04 -0500
From: "Patrick J. Volkerding" <volkerdi@slackware.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Nick Clifton <nickc@specifixinc.com>, Richard Henderson <rth@redhat.com>,
       Ian Taylor <ian@airs.com>, Jeff Law <law@redhat.com>,
       Jim Wilson <wilson@redhat.com>, DJ Delorie <dj@delorie.com>,
       Alan Modra <amodra@bigpond.net.au>,
       Michael Meissner <meissner@redhat.com>,
       Daniel Jacobowitz <dan@debian.org>, linux-kernel@vger.kernel.org
Subject: Re: ld: <...> internal error, aborting at arange-set.c line 202 in
 arange_set_new
References: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Hi,
> 
> For your information;
> I just test build Linus' tip of the kernel tree (HEAD at 
> 064922a805ec7aadfafdd27aa6b4908d737c3c1d) on a up-to-date 
> Slackware-current distro and hit this problem:
> 
> ...
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> ld: size of bfd_vma > size of splay_tree types
> ld: BFD (Linux/GNU Binutils) 2.18.50.0.4.20080208 internal error, aborting 
> at arange-set.c line 202 in arange_set_new
> 
> ld: Please report this bug.

Hello all,

Slackware-current does not use binutils 2.18.50.0.4.20080208, but rather 
binutils-2.17.50.0.17.  We've run into a few unusual issues with newer 
binutils versions, so we tend to be rather cautious about having that 
package on the bleeding edge.

I'd be curious if using the binutils-2.17.50.0.17 package from 
slackware-current would avoid this problem, but also wanted to let 
people know that the system in question had a critical part of the 
toolchain replaced with something that didn't come from our set of packages.

Best regards,

Pat

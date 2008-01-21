Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbYAUVhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYAUVhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYAUVhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:37:11 -0500
Received: from lucidpixels.com ([75.144.35.66]:55157 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbYAUVhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:37:10 -0500
Date: Mon, 21 Jan 2008 16:37:09 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
In-Reply-To: <200801211209.23901.yinghai.lu@sun.com>
Message-ID: <alpine.DEB.0.999999.0801211635480.6668@p34.internal.lan>
References: <200801192045.17291.yinghai.lu@sun.com> <200801210830.22322.jesse.barnes@intel.com> <alpine.DEB.0.999999.0801211413350.10066@p34.internal.lan> <200801211209.23901.yinghai.lu@sun.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Jan 2008, Yinghai Lu wrote:

> On Monday 21 January 2008 11:14:02 am Justin Piszcz wrote:
> please get x86.git
>
>  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>  cd linux-2.6
>  #--------------{ x86.git instructions }---------->
>  # Add Linus's tree as a remote
>  git remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
>  # Add Ingo's tree as a remote
>  git remote add x86 git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>
>  # With that setup, just run the following to get any changes you
>  # don't have.  It will also notice any new branches Ingo/Linus
>  # add to their repo.  Look in .git/config afterwards, the format
>  # to add new remotes is easy to figure out.
>  git remote update
>  #-------------------------
>  git merge x86/master
>  git merge x86/mm
>
> and apply
>
> [PATCH] x86_64: check if Tom2 is enabled
> http://lkml.org/lkml/2008/1/21/20
> [PATCH] x86_64: update e820 instead of updating end_pfn v3
> http://lkml.org/lkml/2008/1/21/19
> [PATCH] x86_32: trim memory by updating e820 v2
> http://lkml.org/lkml/2008/1/21/18
>
> YH
>

Thanks, I am all patched up and ready to test, unfortunately one of my disks
in my RAID 1 just died, I already filled out the advanced replacement form,
I will test when I receive the replacement disk.

p34:~# lilo
Fatal: Not all RAID-1 disks are active; use '-H' to install to active disks only
p34:~# lilo -H
Warning: Partial RAID-1 install on active disks only; booting is not failsafe

Warning: Faulty disk in RAID-1 array; boot with caution!!
Fatal: Unusual RAID bios device code: 0xFF
p34:~#

Don't feel like mucking up my system at the moment.

Justin.


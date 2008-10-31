Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYJaLcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYJaLcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYJaLcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:32:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37311 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYJaLcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:32:03 -0400
Date: Fri, 31 Oct 2008 11:32:02 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
Message-ID: <20081031113202.GB9872@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <20081030142632.GA15645@csn.ul.ie> <18698.7794.500191.189515@cargo.ozlabs.ibm.com> <20081031103646.GA24395@csn.ul.ie> <18698.59790.393775.139313@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <18698.59790.393775.139313@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:18:38PM +1100, Paul Mackerras wrote:
> Mel Gorman writes:
> 
> > Yaboot in my case and I've heard it affected a DVD installation. I don't
> > know for sure if it affects netboot but as I think it's something the
> > kernel is doing, it probably doesn't matter how it gets loaded?
> 
> I do need to know whether it was the vmlinux or the zImage.pseries
> that you were loading with yaboot.  That commit you identified affects
> the contents of an ELF note in the zImage.pseries that firmware looks
> at, as well as a structure in the kernel itself that gets passed as an
> argument to a call to firmware.  If you were loading a vmlinux with
> yaboot when you saw the corruption occur then that narrows things down
> a bit.
> 

It's the vmlinux file I am seeing problems with.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

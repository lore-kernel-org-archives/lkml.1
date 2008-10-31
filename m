Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbYJaLSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbYJaLSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYJaLSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:18:44 -0400
Received: from ozlabs.org ([203.10.76.45]:42226 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYJaLSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:18:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18698.59790.393775.139313@cargo.ozlabs.ibm.com>
Date: Fri, 31 Oct 2008 22:18:38 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
In-Reply-To: <20081031103646.GA24395@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	<20081030142632.GA15645@csn.ul.ie>
	<18698.7794.500191.189515@cargo.ozlabs.ibm.com>
	<20081031103646.GA24395@csn.ul.ie>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman writes:

> Yaboot in my case and I've heard it affected a DVD installation. I don't
> know for sure if it affects netboot but as I think it's something the
> kernel is doing, it probably doesn't matter how it gets loaded?

I do need to know whether it was the vmlinux or the zImage.pseries
that you were loading with yaboot.  That commit you identified affects
the contents of an ELF note in the zImage.pseries that firmware looks
at, as well as a structure in the kernel itself that gets passed as an
argument to a call to firmware.  If you were loading a vmlinux with
yaboot when you saw the corruption occur then that narrows things down
a bit.

Paul.

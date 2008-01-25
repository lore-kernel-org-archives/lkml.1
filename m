Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbYAYIxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbYAYIxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYAYIxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:53:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:46049 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYAYIxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:53:37 -0500
Date: Fri, 25 Jan 2008 02:50:20 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Jochen Friedrich <jochen@scram.de>
cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCHv3 0/7] [POWERPC] 8xx cleanups
In-Reply-To: <4798AB95.8040405@scram.de>
Message-ID: <Pine.LNX.4.64.0801250249170.11624@blarg.am.freescale.net>
References: <4798AB95.8040405@scram.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Jochen Friedrich wrote:

> Hi,
>
> this is a series against paulus for-2.6.25 tree to clean up various 8xx
> related stuff.
> The series can be pulled from git://git.bocc.de/dbox2.git cleanup.
> Old patches 2+4 have been merged into Patch 2. Patch 4 has been modified to
> move the
> prototypes into a new platforms/8xx/mpc8xx.h. Patch 5 leaves the PCMCIA bits
> in
> asm-powerpc/mpc8xx.h as this driver needs to be fixed first (unfortunately, i
> don't
> have an 8xx board with PCMCIA). I would suggest removing asm-powerpc/mpc8xx.h
> after
> ARCH=ppc is gone to avoid adding #ifdefs to all shared drivers.
>
> I also modified an option in Thunderbird so i hope whitespaces are OK now :-/
>
> [POWERPC] Remove unused m8xx_cpm_hostalloc/free/dump()
> [POWERPC] Rename m8xx_pic_init to mpc8xx_pics_init
> [POWERPC] Remove unneeded and misspelled prototype m8xx_calibrate_decr
> [POWERPC] Remove sysdev/commproc.h
> [POWERPC] Get rid of conditional includes of board specific setup

I've applied the above patches.

> [POWERPC] Rename commproc to cpm1 and cpm2_common.c to cpm2.c

I'm a bit concerned this patch is touching too many files.. or ones that
it never should have.

> [POWERPC] Move definition of buffer descriptor to cpm.h

I'm assmuing this patch depends on the previous one.

- k

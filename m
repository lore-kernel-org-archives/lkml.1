Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYJ3UwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYJ3UwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYJ3UwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:52:08 -0400
Received: from ozlabs.org ([203.10.76.45]:34599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYJ3UwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:52:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
Date: Fri, 31 Oct 2008 07:52:02 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
In-Reply-To: <20081030142632.GA15645@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	<20081030142632.GA15645@csn.ul.ie>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman writes:

> On some ppc64 machines, NVRAM is being corrupted very early in boot (before
> console is initialised). The machine reboots and then fails to find yaboot
> printing the error "PReP-BOOT: Unable to load PRep image".  It's nowhere near
> as serious as the ftrace+e1000 problem as the machine is not bricked but it's
> fairly scary looking, the machine cannot boot and the fix is non-obvious. To
> "fix" the machine;
> 
> 1. Go to OpenFirmware prompt
> 2. type dev nvram
> 3. type wipe-nvram
> 
> The machine will reboot, reconstruct the NVRAM using some magic and yaboot
> work again allowing an older kernel to be used. I bisected the problem down
> to this commit.

Eek!

Which ppc64 machines has this been seen on, and how were they being
booted (netboot, yaboot, etc.)?

Is it just the Powerstations with their SLOF-based firmware, or is it
IBM pSeries machines as well?

Paul.

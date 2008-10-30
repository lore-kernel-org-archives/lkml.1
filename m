Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYJ3VgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYJ3VgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYJ3Vfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:35:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43930 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYJ3Vfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:35:50 -0400
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot
	(bisected)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Mel Gorman <mel@csn.ul.ie>,
       linuxppc-dev@ozlabs.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081030210522.GA6532@yoda.jdub.homelinux.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	 <20081030142632.GA15645@csn.ul.ie>
	 <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
	 <20081030210522.GA6532@yoda.jdub.homelinux.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:35:47 -0500
Message-Id: <1225402547.3322.29.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 17:05 -0400, Josh Boyer wrote:
> On Fri, Oct 31, 2008 at 07:52:02AM +1100, Paul Mackerras wrote:
> >Mel Gorman writes:
> >
> >> On some ppc64 machines, NVRAM is being corrupted very early in boot (before
> >> console is initialised). The machine reboots and then fails to find yaboot
> >> printing the error "PReP-BOOT: Unable to load PRep image". 
...
> >Eek!
> >
> >Which ppc64 machines has this been seen on, and how were they being
> >booted (netboot, yaboot, etc.)?
> >
> >Is it just the Powerstations with their SLOF-based firmware, or is it
> >IBM pSeries machines as well?
> 
> I'm pretty sure it was with pSeries machines.  I saw reports of POWER5
> being effected (p520 and p710).  I believe one of them resolved the
> issue by upgrading firmware on the machine.

This is true of a p720 (CHRP IBM,9124-720) that I was testing on.  With
upgraded firmware, the problem is gone.

-- 
David Kleikamp
IBM Linux Technology Center


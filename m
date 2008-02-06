Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbYBFIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbYBFIOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758751AbYBFIOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:14:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:39678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432AbYBFIOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:14:03 -0500
From: Andi Kleen <ak@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] [1/2] Move NUMAQ io handling into arch/x86/pci/numa.c
Date: Wed, 6 Feb 2008 09:15:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       apw@shadowen.org
References: <20080201608.475239056@suse.de> <20080205222603.GB4207@csn.ul.ie>
In-Reply-To: <20080205222603.GB4207@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060915.01121.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +#define XQUAD_PORTIO_BASE 0xfe400000
>
> There is still a definition in include/asm-x86/io_32.h . Is this
> intentional?

Probably not.

>
> > +extern void *xquad_portio;    /* Where the IO area was mapped */
>
> Does the extern need to be here when you've added it (minus the comment)
> to mach_apic.h later in the patch?

The extern was intended to be removed, but somehow that change didn't make 
it into the final patch. Doesn't matter much either way though.

> Fix for "x86: move NUMAQ io handling into arch/x86/pci/numa.c"
>
> The intention of commit c7e844f0415252c7e1a2153a97e7a0c511d61ada was to
> replace a number of outl_quad() calls with a writel() equivilant. One of
> the changes was not equivilant. This patch corrects it.

Yes looks good; thanks.

-Andi

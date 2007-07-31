Return-Path: <linux-kernel-owner+w=401wt.eu-S940684AbXGaCTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940684AbXGaCTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937347AbXGaCQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:46 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53457 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966487AbXGaCQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:40 -0400
Date: Mon, 30 Jul 2007 19:16:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2.6.23-rc1 REGRESSION] CPU hotplug totally broken on HPC
	nx6325 (x86_64)
Message-ID: <20070731021622.GE3673@sequoia.sous-sol.org>
References: <200707261440.50649.rjw@sisk.pl> <alpine.LFD.0.999.0707260924150.3442@woody.linux-foundation.org> <20070731012340.GD3673@sequoia.sous-sol.org> <alpine.LFD.0.999.0707301845380.4161@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707301845380.4161@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Mon, 30 Jul 2007, Chris Wright wrote:
> > This also fixes paravirt patching which was broken when text_poke()
> > tried to patch the various pv ops in lookup_address.
> 
> Hmm. What is "this"? The revert? 

Yes, sorry, your revert also fixes paravirt patching.

> That said, I do wonder whether virtualization still has problems with 
> CONFIG_RODATA, though. We limit the RODATA memory ranges based on KPROBES 
> and HOTPLUG_CPU, but not based on VIRTUALIZATION.
> 
> I'd expect any virtualization fixups to hit the same problems that the SMP 
> alternatives hit. No?

Hmm, patching should've already happened, and aside of module loading,
isn't typically done again.  I think it's OK as it is.

thanks,
-chris

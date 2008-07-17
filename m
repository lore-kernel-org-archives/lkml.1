Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYGQAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYGQAYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYGQAYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:24:07 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61229 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752779AbYGQAYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:24:06 -0400
Date: Thu, 17 Jul 2008 01:23:50 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull] PCI pull request for 2.6.27
In-Reply-To: <200807161654.55699.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.55.0807170109470.30858@cliff.in.clinika.pl>
References: <200807161639.24289.jbarnes@virtuousgeek.org>
 <alpine.LFD.1.10.0807161647470.2835@woody.linux-foundation.org>
 <200807161654.55699.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008, Jesse Barnes wrote:

> Yeah I noticed that too when I did the merge (and in the original patch), 
> though on my 80 char display it looked like a wash in terms of readability to 
> me, but even in that case I should have rejected it as noise.  Sorry about 
> that.

 Conveniently "for" is short enough for indentation like this:

	for (addr = (u8 *) __va(0xf0000);
	     addr < (u8 *) __va(0x100000);
	     addr += 16) {
                rt = pirq_check_routing_table(addr);

to make the piece of code both well-readable and polite to the right edge
of the terminal.  That would be my preference -- I hope you agree.

 Of course, in many cases it may be better to make use of auxiliary
variables instead.  GCC has to evaluate the expressions used anyway and
any names given to them come for free for any half-decent version of the
compiler.

  Maciej

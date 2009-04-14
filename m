Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZDNB2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZDNB2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZDNB2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:28:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbZDNB2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:28:31 -0400
Date: Mon, 13 Apr 2009 18:19:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Michal Simek <michal.simek@petalogix.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PULL, v3] Microblaze architecture (arch/microblaze/)
 support
In-Reply-To: <49DC4024.6090800@petalogix.com>
Message-ID: <alpine.LFD.2.00.0904131818050.26713@localhost.localdomain>
References: <49DC4024.6090800@petalogix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Apr 2009, Michal Simek wrote:
> 
> This repository contains Linux support for Xilinx Microblaze CPU.
> 
> Please pull
>     git://git.monstr.eu/linux-2.6-microblaze.git for-linus

So I pulled, but I notice that there's a few empty header files.

That looks intentional (they came in through a commit that says "headers 
simple files - empty or redirect to asm-generic"), but it means that "make 
distclean" will remove them. So if you really want an empty header file, 
you should really make it not _completely_ empty - add a comment to it or 
something.

		Linus

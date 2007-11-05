Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbXKEKlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbXKEKlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXKEKlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:41:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40424 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbXKEKll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:41:41 -0500
Date: Mon, 5 Nov 2007 10:41:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071105104129.GB3662@infradead.org>
References: <20071103234826.GA26654@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103234826.GA26654@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 12:48:26AM +0100, Sam Ravnborg wrote:
> This patchset unify the i386 and x86_64 Kconfig
> files for x86.
> In addition it replaces the use of ARCH=i386 and
> ARCH=x86_64 with the more intuitive ARCH=x86.
> 
> The primary purpose of this patch serie is to 
> enable make ARCH=x86 and let the config decide
> if we are building for 32 or 64 bit.

Nice!  Thanks a lot for the work.

> But we will break quite a high number of
> scripts with this change.
> What is the desired behaviour when specifying:
> make ARCH=i386
> and
> make ARCH=x86_64
> ??
> 
> For now it just error out like this:
> $ make ARCH=i386
> Makefile:503: /home/sam/kernel/x86.git/arch/i386/Makefile: No such file or directory
> make: *** No rule to make target `/home/sam/kernel/x86.git/arch/i386/Makefile'.  Stop.

Sounds fine, other architectures had that exactly same issue before.  Maybe
we can add a more useful message thouigh like

$ARCH does not exist for any non-existant arch.


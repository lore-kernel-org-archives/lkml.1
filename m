Return-Path: <linux-kernel-owner+w=401wt.eu-S1765953AbZDJLfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765953AbZDJLfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765969AbZDJLfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:35:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761452AbZDJLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:35:22 -0400
Date: Fri, 10 Apr 2009 13:38:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090410113824.GA18823@elf.ucw.cz>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410112546.GD21506@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, difference is that you can defend against arbitrary network 
> > packet, but you can't defend against arbitrarily broken BIOS. If 
> > it loops forever, or overwrites random memory place, we lost...
> 
> We could protect against random memory corruption too, if it ever 
> became a widespread problem: by executing the BIOS call in a virtual 
> machine. (We can probably use the KVM code to properly emulate big 
> real mode, etc.)

We already have problems where bios corrupts low memory area during
suspend/resume. Not sure how KVM helps.

Anyway I do agree with the patches.

> "BIOS people" are operating in a completely different culture. Time 
> to market, hardware workarounds, short-term differentiators, secret 
> bootstrap sequences and code compactness are king in that space. 
> Code quality is dead last in the list. I strongly doubt that given 
> the radically conflicting priorities a reasonable dialogue can be 
> established.

"BIOS people" control stuff like SMM mode. We can workaround some BIOS
problems, but definitely not all of them.

For servers, I guess Linux has enough of market share that we could
certify known-good servers (and maybe warn against known-bad).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

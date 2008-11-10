Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYKJUju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYKJUju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYKJUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:39:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:37719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbYKJUjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:39:39 -0500
From: Andreas Schwab <schwab@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	<wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
X-Yow: Uh-oh!!  I'm having TOO MUCH FUN!!
Date: Mon, 10 Nov 2008 21:39:35 +0100
In-Reply-To: <1226295985.7731.7.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 10 Nov 2008 16:46:25 +1100")
Message-ID: <jetzafiad4.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> radeonfb: Fix accel problems with new imageblit hook
>
> Some radeon chips have issues with color expansion of pixmaps that
> aren't a multiple of 32 pixels wide. This works around it the same
> way X does by requesting the right pitch alignment from fbcon and
> then using the chip scissors to do clipping to the requested size.

Unfortunately this does not fix the suspend regression on PowerBook6,7.
Instead I have to use the workaround in
<http://marc.info/?l=linux-kernel&m=122515268301239&w=2>.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

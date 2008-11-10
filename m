Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYKJJGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYKJJGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYKJJFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:05:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:55660 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbYKJJFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:05:52 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Collins <paul@burly.ondioline.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <87abc8rr3m.fsf@burly.wgtn.ondioline.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <87abc8rr3m.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 20:05:21 +1100
Message-Id: <1226307921.10430.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 20:13 +1300, Paul Collins wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > On Sun, 2008-11-09 at 18:59 +0100, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >> 
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.27.  Please verify if it still should be listed and let me know
> >> (either way).
> >
> > Allright, so I finally managed to find a machine to reproduce it and
> > I have a patch that fixes it here. I'm basically implementing the same
> > thing as X which is to ensure the bitmap is padded to 32 pixels.
> 
> Works great here (as you might expect).

Yeah, well, Albook G4 with rv350, I think we have the same machine :-)

Ben.



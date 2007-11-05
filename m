Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbXKEVsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbXKEVsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXKEVsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:48:01 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39924 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXKEVsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:48:00 -0500
Date: Mon, 5 Nov 2007 22:49:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071105214937.GA31496@uranus.ravnborg.org>
References: <20071103234826.GA26654@uranus.ravnborg.org> <20071105104129.GB3662@infradead.org> <20071105171740.GA29481@uranus.ravnborg.org> <adafxzkbcid.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adafxzkbcid.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 01:36:42PM -0800, Roland Dreier wrote:
>  > Like this:
>  > $ make ARCH=foo
>  > Makefile:201: *** "ERROR: ARCH (foo) does not exist".  Stop.
> 
> Seems sane, but maybe it would be worth putting in a special case
> check for someone using i386 or x86_64 for ARCH, and tell them to
> switch to x86?

Will do so if my patchset gets applied. Need to redo it but
that will be later this week and then I hope for a bit more
feedback from the x86 guys.

	Sam

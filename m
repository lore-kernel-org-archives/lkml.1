Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYAVVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYAVVKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYAVVKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:10:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbYAVVKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:10:32 -0500
Date: Tue, 22 Jan 2008 22:10:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080122211014.GA27870@elte.hu>
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47965806.6080903@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:

> > The attached patch rearranges the code so that the handler is 
> > installed before we setup the interrupt (so we have somebody to 
> > listen to the immediate interrupt), and it makes sure that we clear 
> > the event in the IRQ handler regardless of the state of the timer 
> > tick.
> 
> This patch indeed solves the problem. The board boots fine. Great 
> work!

since this driver is new in 2.6.24, perhaps we should apply this fix to 
v2.6.24?

	Ingo

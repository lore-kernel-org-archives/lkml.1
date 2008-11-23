Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbYKWNYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbYKWNYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYKWNYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:24:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbYKWNYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:24:16 -0500
Date: Sun, 23 Nov 2008 14:23:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
Message-ID: <20081123132346.GE1178@elte.hu>
References: <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123090828.GA31490@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Impact: cleanup of entry_64.S
> 
> Except for the order and the place of the functions, this
> patch should not change the generated code.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
>  arch/x86/kernel/entry_64.S |  259 +++++++++++++++++++-------------------------
>  1 files changed, 109 insertions(+), 150 deletions(-)

applied to tip/x86/irq, thanks Alexander!

> > Something like:
> > 
> >   PARANOID_ERROR_ENTRY(stack_segment)
> 
> I chose to just reuse the existing names, but it's bikeshedding, so 
> change it if you like ;)

yeah. But such things, if they pile up long enough, can result in real 
problem. entry_64.S is the result of such a degenerative process.

> I now know why I did not hit the bug that was fixed by "x86: split 
> out some macro's and move common code to paranoid_exit, fix"... 
> *blush* I was doing my real-world testing using an i386-image of 
> debian.

heh, that indeed explains :)

	Ingo

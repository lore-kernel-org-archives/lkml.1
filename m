Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYKDQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYKDQ4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYKDQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:56:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbYKDQ4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:56:14 -0500
Date: Tue, 4 Nov 2008 17:55:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081104165548.GA696@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <1225813659.22738.1282932197@webmail.messagingengine.com> <20081104163636.GA20534@elte.hu> <1225817106.2795.1282945873@webmail.messagingengine.com> <20081104165409.GA511@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104165409.GA511@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > > My estimation is that if we do it right, your approach will behave 
> > > better on modern CPUs (which is what matters most for such 
> > > things), especially on real workloads where there's a considerable 
> > > instruction-cache pressure. But it should be measured in any case.
> > 
> > Fully agreed. I will do some measurements in the near future, maybe 
> > next week. At least noone came up with an absolutely blocking 
> > problem with this approach ;).
> 
> how about "it does not build with lguest enabled" as a blocking 
> problem? ;-)
> 
>   arch/x86/lguest/built-in.o: In function `lguest_init_IRQ':
>   boot.c:(.init.text+0x33f): undefined reference to `interrupt'
> 
> config attached.

... other than that it booted fine on a few testboxes here. That's 
still not an exhaustive test by any means, but it's promising.

	Ingo

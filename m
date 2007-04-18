Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXDRWCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXDRWCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXDRWCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:02:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbXDRWCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:02:47 -0400
Date: Thu, 19 Apr 2007 00:02:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070418220228.GA14536@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704182357.28107.mail@earthworm.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Hesse <mail@earthworm.de> wrote:

> > although probably your suspend2 problem is still not fixed, it's 
> > worth a try nevertheless. Which suspend2 patch did you apply, and 
> > was it against -rc6 or -rc7?
> 
> You are right again. ;-)
> 
> Linux 2.6.21-rc7
> Suspend2 2.2.9.11 (applies cleanly to -rc7)
> CFS v3 (without any additional patches)
> 
> And it still hangs on suspend.

what's the easiest way for me to try suspend2? Apply the patch, reboot 
into the kernel, then execute what command to suspend? (there's a 
confusing mismash of initiators of all the suspend variants. Can i drive 
this by echoing to /sys/power/state?)

	Ingo

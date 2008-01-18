Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbYARJKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbYARJKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYARJJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:09:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYARJJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:09:57 -0500
Date: Fri, 18 Jan 2008 10:09:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: add is_f00f_bug helper to fault_32|64.c
Message-ID: <20080118090945.GD24337@elte.hu>
References: <1200610456.5724.41.camel@brick> <p73d4rzbudl.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73d4rzbudl.fsf@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Harvey Harrison <harvey.harrison@gmail.com> writes:
> 
> > Further towards unifying these files, add another helper in same 
> > spirit as is_errata93.
> 
> The better way to handle this would be to move all these workarounds 
> into notifiers that only get registered on the CPUs that actually have 
> the bugs.
> 
> There is right now no die notifier in the right place for this, but 
> you could just add one there. This is no performance critical place.

agreed in principle, but i think it's perhaps a bit more maintainable if 
we first aimed for unification, then did such cleanups ontop of the 
unified code. Almost everything we do prior unification is double the 
work.

	Ingo

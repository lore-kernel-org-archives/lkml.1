Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZB1InS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZB1InS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZB1InK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:43:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZB1InI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:43:08 -0500
Date: Sat, 28 Feb 2009 09:42:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090228084254.GA29342@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227212812.26d02f34.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I hate to be the one to say it, but we should sit down and 
> work out whether it is justifiable to merge any of this into 
> Linux.  I think it's still the case that the Xen technology is 
> the "old" way and that the world is moving off in the "new" 
> direction, KVM?
> 
> In three years time, will we regret having merged this?

Personally i'd like to see a sufficient reply to the mmap-perf 
paravirt regressions pointed out by Nick and reproduced by 
myself as well. (They were in the 4-5% macro-performance range 
iirc, which is huge.)

So i havent seen any real progress on reducing native kernel 
overhead with paravirt. Patches were sent but no measurements 
were done and it seemed to have all fizzled out while the dom0 
patches are being pursued.

Which is not a particularly good basis on which to add even 
_more_ paravirt stuff, is it?

	Ingo

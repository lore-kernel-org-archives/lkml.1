Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZELQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZELQSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZELQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:18:42 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33068 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbZELQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:18:41 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Nick Piggin" <npiggin@suse.de>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
References: <4A09AF8402000078000007DC@vpn.id2.novell.com>
X-Yow: I was making donuts and now I'm on a bus!
Date: Tue, 12 May 2009 18:18:37 +0200
In-Reply-To: <4A09AF8402000078000007DC@vpn.id2.novell.com> (Jan Beulich's
	message of "Tue, 12 May 2009 16:19:00 +0100")
Message-ID: <m2vdo6l2g2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <JBeulich@novell.com> writes:

> While looking at a completely different issue I happened to grep for uses of
> xadd, and it would appear to me that there got uses added that would make
> a M386-configured SMP kernel die on an actual i386.
>
> Oh, for the rwsem case I see - it would use the RWSEM_GENERIC_SPINLOCK case
> when selecting M386. But I see nothing similar for the ticket spinlocks - am
> I overlooking something?

This came up before, see
<http://marc.info/?l=linux-kernel&m=123141659309208&w=2>.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

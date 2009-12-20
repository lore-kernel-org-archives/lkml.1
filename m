Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZLTRhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZLTRhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZLTRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:37:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZLTRhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:37:43 -0500
Date: Sun, 20 Dec 2009 18:37:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, San Mehat <san@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: sched: restore sanity
Message-ID: <20091220173727.GA12897@elte.hu>
References: <1261315437.4314.6.camel@laptop>
 <20091220144925.GA19608@elte.hu>
 <1261320715.4314.9.camel@laptop>
 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
 <1261322387.4314.22.camel@laptop>
 <1261329743.30458.179.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261329743.30458.179.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Sun, 2009-12-20 at 16:19 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> > > >> Probably, but the rest is just as annoying, pr_* is crap.
> > > Oh? Out of curiosity whats wrong with it?
> > That's what should be asked of printk().
> 
> pr_<level> offers some things printk cannot:
> 
> o standardization, eliminates frequent missing KERN_ levels
>   and missing/typo/misspelled module prefixes  
> o visually shorter, fewer chars used, less 80 char wrapping
> o finer grained ability to eliminate unnecessary messages
>   for embedded systems
> o standardized mechanism to prefix messages with module/function
> o eventual code reduction via use of a singleton instead of
>   duplicated module/function names
> o eventual dynamic_debug styled control of prefix by
>   module/function

These are pretty marginal advantages - borderline not worth the resulting 
churn. But borderline good patch is still a good patch in my book so i applied 
it. Btw., i wish you mixed with real kernel code too instead of going down the 
Bunk path. That would reduce such friction substantially IMO - people would 
see that you are willing to do (and capable of doing) the harder stuff too.

Thanks,

	Ingo

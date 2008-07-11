Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYGKIvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYGKIvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYGKIvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:51:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYGKIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:51:44 -0400
Date: Fri, 11 Jul 2008 10:51:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce max_low_pfn_mapped for 64bit
Message-ID: <20080711085131.GA20987@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <20080711082601.GC4427@elte.hu> <86802c440807110139x429cdc41wc95a208c5e000ee3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807110139x429cdc41wc95a208c5e000ee3@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Jul 11, 2008 at 1:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> when 4g more memory installed, don't map big hole below 4g.
> >
> > applied to tip/x86/core, thanks Yinghai.
> >
> > This is a scarier change - no way to do it in smaller steps?
> 
> 1. e820_end ==> e820_end_of_ram_pfn :: totally safe...
> 2. others

yeah. I'd also split out the introduction of max_low_pfn_mapped into a 
separate, safe patch as well. I.e. first patch just introduces it, 
second patch makes use of it.

the #ifdef 64-bit assymetry looks a bit ugly too.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZKJExs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZKJExs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZKJExr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:53:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZKJExr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:53:47 -0500
Date: Tue, 10 Nov 2009 05:53:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic: Do not use stacked physid_mask_t
Message-ID: <20091110045322.GC7897@elte.hu>
References: <20091109220659.GA5568@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109220659.GA5568@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi all,
> 
> during the conversation about physid_mask_t passed
> via stack
> 
> 	http://lkml.org/lkml/2009/11/8/139
> 	http://lkml.org/lkml/2009/11/8/244
> 	http://lkml.org/lkml/2009/11/9/43
> 
> the idea of moving masks via pointers not just for
> x86-64 (we even don't use those masks there but still
> have function declarations in struct apic) but for x86-32
> as well (ie more naturally -- as we operate with "struct cpumask")
> found to be usefull.
> 
> As a result -- the following patch. Note that it's
> big enough and though I was trying to be carefull
> I would really appreciate more detailed review and
> comments and _complains_ as well.

No complaints from me - this is the cleanup i was striving for. Will let 
you know if i see any test failures.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYJXInx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYJXInx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYJXInp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:43:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYJXIno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:43:44 -0400
Date: Fri, 24 Oct 2008 10:38:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Keith Packard <keithp@keithp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, nickpiggin@yahoo.com.au,
       airlied@linux.ie, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Peter Anvin <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org
Subject: Re: Adding kmap_atomic_prot_pfn
Message-ID: <20081024083830.GB6734@elte.hu>
References: <20081020115810.GC10594@elte.hu> <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu> <1224793332.22877.8.camel@koto.keithp.com> <20081023133840.d4eef579.akpm@linux-foundation.org> <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org> <1224813015.22877.51.camel@koto.keithp.com> <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org> <1224829359.22877.86.camel@koto.keithp.com> <49017A2C.5010504@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49017A2C.5010504@tungstengraphics.com>
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


* Thomas Hellström <thomas@tungstengraphics.com> wrote:

> Keith,
>
> What you actually are doing here is claiming copyright on code that 
> other people have written, and tighten the export restrictions.  
> kmap_atomic_prot_pfn() appeared long ago in drm git with identical 
> code and purpose, but with different authors, and iounmap_atomic is 
> identical to kunmap_atomic.

>> +EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);

you want to use this facility in a binary-only driver?

	Ingo

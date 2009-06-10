Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbZFJLDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbZFJLDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZFJLCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:02:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZFJLCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:02:53 -0400
Date: Wed, 10 Jun 2009 13:02:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
Message-ID: <20090610110244.GE27724@elte.hu>
References: <20090609082931.GD25316@prithivi.gnumonks.org> <1244537598.2558.9.camel@ht.satnam> <20090609145305.GD3986@prithivi.gnumonks.org> <20090609151557.GA9362@elte.hu> <4A2F353A.9040007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2F353A.9040007@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@kernel.org> wrote:

> Ingo Molnar wrote:
> > 
> > MSRs should really be enumerated along CPU features. They will be 
> > accessed if a CPU offers that CPU feature.
> > 
> 
> Nice in theory, but so many MSRs have to be enumerated with obscure test
> combinations, that it really isn't practical in the general case.  That
> is why we have the safe MSR variants.
> 
> > 
> > Yeah, the safe read should never fault - there should be all 
> > zeroes or an error return.
> > 
> 
> Error return, MSRs #GP if not present.  All zero means a present 
> MSR (which is zero.)

yes, of course - i meant the /debug/x86/cpu/* behavior: it should 
either result zeroes, or should return -EINVAL. (probably the 
latter)

	Ingo

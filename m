Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbYA3TJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbYA3TJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757848AbYA3TJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:09:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbYA3TJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:09:11 -0500
Date: Wed, 30 Jan 2008 20:08:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/test_nx.c compile error
Message-ID: <20080130190856.GA4221@elte.hu>
References: <20080130182537.GD29368@does.not.exist> <20080130184218.GB27168@elte.hu> <20080130184432.GA31485@elte.hu> <20080130190004.GG29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130190004.GG29368@does.not.exist>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> > +#ifdef CONFIG_X86_32
> > +		"	.long 0b\n"
> > +		"	.long 2b\n"
> > +#endif
> >  		"	.quad 0b\n"
> >  		"	.quad 2b\n"
> > +#else
> >...
> 
> You don't test whether your patches compile?  ;-)

i did - but i didnt test whether i sent you the right, fixed one :-)

> After the obvious fix it compiled.
> 
> Why wasn't this issue found before it entered Linus' tree?

because it was a relatively late patch and TEST_NX is dependent on a 
modular build - which i dont test that often. I found and fixed a mirror 
image bug in test_rodata.c.

	Ingo

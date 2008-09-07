Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYIGJOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYIGJOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYIGJOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:14:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40605 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYIGJOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:14:32 -0400
Date: Sun, 7 Sep 2008 11:13:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 11/13] genapic: reduce stack pressuge in io_apic.c step 3
	target_cpus
Message-ID: <20080907091332.GC5574@elte.hu>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080906235038.421559000@polaris-admin.engr.sgi.com> <36ca99e90809070055u3b3b8415i2a5dbfb6bf617d35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90809070055u3b3b8415i2a5dbfb6bf617d35@mail.gmail.com>
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


> > +#ifdef CONFIG_X86_64
> > +#define TARGET_CPUS(retval)      (genapic->target_cpus)(&(retval))
> > +#else
> > +#define TARGET_CPUS(retval)      retval = (genapic->target_cpus())
> > +#endif

hm, this should be unified.

	Ingo

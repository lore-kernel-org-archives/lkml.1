Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYFKIwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYFKIwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYFKIwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:52:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49910 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYFKIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:52:13 -0400
Date: Wed, 11 Jun 2008 10:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: reserve_bootmem_generic in early_res_to_bootmem
Message-ID: <20080611085201.GA9105@elte.hu>
References: <86802c440806091307r3c4d5e77h12e22abfe578769f@mail.gmail.com> <86802c440806091915w273bbb3ck745886e06341eeb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806091915w273bbb3ck745886e06341eeb0@mail.gmail.com>
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

> >                printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
> >                        final_start, final_end - 1, r->name);
> > -               reserve_bootmem_generic(final_start, final_end - final_start,
> > +               reserve_bootmem(final_start, final_end - final_start,
> >                                BOOTMEM_DEFAULT);
> >        }
> >  }
> >
> 
> or we need add reserve_bootmem_generic for 32 bit?

yes, that would be really nice - instead of the ifdeffery.

	Ingo

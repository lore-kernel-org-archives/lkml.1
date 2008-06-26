Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYFZLBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYFZLBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYFZLBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:01:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYFZLBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:01:42 -0400
Date: Thu, 26 Jun 2008 13:01:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Huang@elte.hu, Ying <ying.huang@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 00/16] x86: merge setup_32/64.c
Message-ID: <20080626110113.GA14513@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <20080626094743.GA19573@elte.hu> <20080626100200.GA15291@elte.hu> <86802c440806260306o419f2369od90f1cb3c801311e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806260306o419f2369od90f1cb3c801311e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: checkpatch.pl]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  #include <asm/mpspec.h>
> >  #include <asm/setup.h>
> >  #include <asm/arch_hooks.h>
> > +#include <asm/efi.h>
> >  #include <asm/sections.h>
> >  #include <asm/dmi.h>
> >  #include <asm/io_apic.h>
> 
> checkpatch.pl want me to remove that.

checkpatch.pl is right about that, but the proper fix would be to decode 
this dependency - why isnt it enough to include linux/efi.h?

	Ingo

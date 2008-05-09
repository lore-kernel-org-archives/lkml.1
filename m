Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYEIIdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYEIIdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYEIIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:33:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYEIIdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:33:08 -0400
Date: Fri, 9 May 2008 10:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: rtc-cmos.c: Build fix
Message-ID: <20080509083258.GB2592@elte.hu>
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <20080506124348.GR32591@elte.hu> <20080506185125.GA12844@beyonder.ift.unesp.br> <20080507143115.ed738026.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507143115.ed738026.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 May 2008 15:51:25 -0300
> "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
> 
> > Subject: [PATCH] rtc-cmos.c: Build fix
> > 
> > The function hpet_rtc_interrupt(..) is to be used only if CONFIG_HPET_EMULATE_RTC
> > is defined (see arch/x86/kernel/hpet.c), so we define it to return 0 when
> > !CONFIG_HPET_EMULATE_RTC to avoid build failures. 
> > 
> > This function will never be used anyways when !CONFIG_HPET_EMULATE_RTC because 
> > it is inside a if(is_hpet_enabled()) which is never true when
> > !CONFIG_HPET_EMULATE_RTC.
> 
> I've lost the plot on this one.  Could we please have a description of 
> the problem which is being fixed?  ie, the compiler (or linker?) 
> output, and a description of why it is occurring?

dont have the build failure log around anymore, but the config is:

   http://redhat.com/~mingo/misc/config-Sun_May__4_09_41_21_CEST_2008.bad

	Ingo

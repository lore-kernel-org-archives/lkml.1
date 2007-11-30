Return-Path: <linux-kernel-owner+w=401wt.eu-S935396AbXK3RHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935396AbXK3RHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbXK3RHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:07:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148AbXK3RHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:07:34 -0500
Date: Fri, 30 Nov 2007 18:06:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Andi Kleen <ak@suse.de>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Message-ID: <20071130170655.GA10868@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org> <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com> <200711301134.04719.ak@suse.de> <029E5BE7F699594398CA44E3DDF554440105236A@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF554440105236A@swsmsx413.ger.corp.intel.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >> Not yet. We are talking to internal teams regarding gdb support.
> >
> >But you already have reasonably realistic test code right?
> 
> I wrote a small program to talk to ptrace and look at the trace of 
> small sample programs to test the patch. I do this on P4 32bit and 
> Core2 64bit.
> 
> Our debugger team has a prototype implementation for their debugger. 
> But that will not be available for some time.
> 
> I hope that we get gdb support, soon, but that would take a while if I 
> had to do it.

i'm wondering what the main use-case would be then, and what the gdb 
folks think about the current API. (Roland?)

	Ingo

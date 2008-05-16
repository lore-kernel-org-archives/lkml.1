Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYEPMGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYEPMGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYEPMGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:06:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYEPMGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:06:11 -0400
Date: Fri, 16 May 2008 14:05:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       pq@iki.fi, proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] ftrace ported to PPC
Message-ID: <20080516120535.GB11718@elte.hu>
References: <20080515034942.109223655@goodmis.org> <18475.48822.311219.341385@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18475.48822.311219.341385@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Steven Rostedt writes:
> 
> > The following two patches ports ftrace to PowerPC. I tested this on 
> > both my PPC64 box as well as my 32bit PowerBook G4.
> 
> Very cool!  Thanks.

great - could you please send an Acked-by line for those patches?

> > This applies to the latest sched-devel (with some extra hacks to get 
> > that to boot on PPC).
> > 
> > This also depends on the CFLAGS_REMOVE_foo.o patches I sent earlier.
> 
> Ingo, when do you intend to send the ftrace stuff to Linus?  In the 
> next merge window?

yeah, that's the plan, this merge window was too hot already. Right now 
there's an ftrace topic in the -tip tree:

    http://people.redhat.com/mingo/tip.git/README

that contains the latest ftrace patches. Please holler if you see 
something weird in it.

	Ingo

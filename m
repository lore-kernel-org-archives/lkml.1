Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZANHcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZANHcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZANHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:32:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZANHcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:32:10 -0500
Date: Wed, 14 Jan 2009 08:31:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090114073146.GA14767@elte.hu>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins> <20090113123317.GA29926@elte.hu> <20090113181311.GA8075@localdomain> <20090113183420.GB10065@elte.hu> <20090113184202.GB8075@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113184202.GB8075@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Tue, Jan 13, 2009 at 07:34:20PM +0100, Ingo Molnar wrote:
> >
> >* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> >
> >> On Tue, Jan 13, 2009 at 01:33:17PM +0100, Ingo Molnar wrote:
> >> >
> >> >
> >> >VSMP is a clustering solution (default-disabled)
> >> 
> >> Small correction :)
> >> Well, it is a virtualization solution creating single VM across multiple
> >> systems.  Since it is shared memory, we would rather refer to it as SMP or
> >> Virtual SMP rather than a clustering solution.
> >
> > You do have hardware help too to do efficient cross-node memory 
> > traffic, dont you?
> 
> Of course.  A fast backplane interconnect.

... so it's PCs clustered together, and called vSMP, right? ;-)

a neat hack in any case.

	Ingo

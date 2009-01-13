Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZAMMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZAMMOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZAMMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:14:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46840 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbZAMMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:14:33 -0500
Date: Tue, 13 Jan 2009 13:14:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Travis <travis@sgi.com>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113121426.GA29149@elte.hu>
References: <20090112213539.GA10720@gambetta> <496BCA21.2010709@sgi.com> <20090112235156.GC10720@gambetta> <496BD8FB.1050101@sgi.com> <20090113000112.GA10368@elte.hu> <20090113033608.GN23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113033608.GN23848@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > > (And was it determined yet, that a cacheline has to be tossed around 
> > > as well?)
> > 
> > No, that assertion of Andi is wrong.
> 
> For the IPI you always have to toss one cache line around to pass the 
> information.
> 
> Anyways the padding is just to avoid false sharing.

Which is a red herring - the padding was there before the patch, and is 
there after the patch as well.

	Ingo

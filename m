Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbZF3Xag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbZF3Xag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZF3XaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:30:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769AbZF3XaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:30:22 -0400
Date: Wed, 1 Jul 2009 01:30:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and
	improve lpage NUMA support
Message-ID: <20090630233001.GA28830@elte.hu>
References: <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <20090630223138.GH1241@elte.hu> <alpine.DEB.1.10.0906301847260.19482@gentwo.org> <20090630230743.GA17968@elte.hu> <alpine.DEB.1.10.0906301917170.15482@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906301917170.15482@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 1 Jul 2009, Ingo Molnar wrote:
> 
> > Say it says "256 CPUs".
> 
> Ok then you found a bug in the virtualization software ;-).

No, it runs on a 256 CPUs host system, why shouldnt it be possible 
to expose that _possible_ expansion space to a guest instance?

	Ingo

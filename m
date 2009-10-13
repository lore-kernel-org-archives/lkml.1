Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZJMH3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZJMH3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZJMH3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:29:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57702 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbZJMH3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:29:46 -0400
Date: Tue, 13 Oct 2009 09:29:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: David Miller <davem@davemloft.net>, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sf.net
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for
	Intel processors
Message-ID: <20091013072901.GA9610@elte.hu>
References: <1254911461.26976.239.camel@twins> <19148.30773.350036.411105@cargo.ozlabs.ibm.com> <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com> <20091007.134626.238756485.davem@davemloft.net> <20091008200839.GA24354@elte.hu> <7c86c4470910081328r24be0f63ha436b008b66077c4@mail.gmail.com> <20091012090515.GA24031@elte.hu> <7c86c4470910130017s72e0b936u3eee0caba00acd22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470910130017s72e0b936u3eee0caba00acd22@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> > Spreading them all out into architecture code is the far worse 
> > solution, it creates a fragile distributed monster with repeating 
> > patterns - instead we want a manageable central monster ;-) [We are 
> > also quite good at controlling and shrinking monsters in the core 
> > kernel.]
>
> I don't understand this either.
> Why would architecture specific code be more fragile ?

Because similar code spread out and partly duplicated in 22 
architectures is an order of magnitude less maintainable than
a core library.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXGPVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXGPVMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXGPVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:12:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXGPVM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:29 -0400
Date: Mon, 16 Jul 2007 23:12:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux@bohmer.net
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, mathieu.desnoyers@polymtl.ca
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070716211222.GA18661@elte.hu>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <3efb10970707161317h72b30aabq208150b2abde8e5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970707161317h72b30aabq208150b2abde8e5e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Remy Bohmer <l.pinguin@gmail.com> wrote:

> Hello Arjan,
> 
> Thanks for this suggestion.

(please dont top-post, ever. See:
 www.zipworld.com.au/~akpm/linux/patches/stuff/top-posting.txt)

> But I looked at Systemtap before, and as I remember, it is very 
> flexible, but it only traces function calls. (or am I missing 
> something?)

systemtap it should be able to trace variables as well. (as long as 
those variables are not eliminated by gcc)

	Ingo

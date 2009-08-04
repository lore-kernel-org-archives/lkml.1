Return-Path: <linux-kernel-owner+w=401wt.eu-S932727AbZHDJZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbZHDJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZHDJZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:25:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbZHDJZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:25:57 -0400
Date: Tue, 4 Aug 2009 11:25:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090804092540.GA29778@elte.hu>
References: <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> <20090802201132.GE28572@bombadil.infradead.org> <20090802204701.GE25334@ghostprotocols.net> <20090803015430.GG25334@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803015430.GG25334@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> +static void load_perf_bfd_demangle(void)
> +{
> +	void *handle = dlopen("libbfd-2.19.51.0.2-17.fc11.so", RTLD_NOW);

Hm, this does not look like a very generic solution. Is there some 
way to do a library search to figure out the name? I guess a glob 
match on /usr/lib/libbfd*.so?

	Ingo

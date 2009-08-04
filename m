Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbZHDKZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbZHDKZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbZHDKZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:25:08 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:38905 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430AbZHDKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:25:07 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] basic perf support for sparc
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
In-Reply-To: <20090804092540.GA29778@elte.hu>
References: <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten>
	 <20090801082048.GX12579@kernel.dk>
	 <20090801182216.GA25334@ghostprotocols.net>
	 <20090802184148.GB17241@elte.hu>
	 <20090802194454.GC28572@bombadil.infradead.org>
	 <20090802195043.GD24486@elte.hu>
	 <20090802201132.GE28572@bombadil.infradead.org>
	 <20090802204701.GE25334@ghostprotocols.net>
	 <20090803015430.GG25334@ghostprotocols.net>
	 <20090804092540.GA29778@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 11:29:00 +0200
Message-Id: <1249378140.7924.168.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 11:25 +0200, Ingo Molnar wrote:
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > +static void load_perf_bfd_demangle(void)
> > +{
> > +	void *handle = dlopen("libbfd-2.19.51.0.2-17.fc11.so", RTLD_NOW);
> 
> Hm, this does not look like a very generic solution. Is there some 
> way to do a library search to figure out the name? I guess a glob 
> match on /usr/lib/libbfd*.so?

I'd simply go for libbfd.so and raise a bug report against fedora. A
link archive named .so is just stupid.


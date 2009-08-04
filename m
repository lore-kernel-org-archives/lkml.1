Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZHDNCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZHDNCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZHDNCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:02:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55407
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477AbZHDNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:02:04 -0400
Date: Tue, 04 Aug 2009 06:02:12 -0700 (PDT)
Message-Id: <20090804.060212.01750529.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, acme@redhat.com, kyle@mcmartin.ca, jens.axboe@oracle.com,
       anton@samba.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249378140.7924.168.camel@twins>
References: <20090803015430.GG25334@ghostprotocols.net>
	<20090804092540.GA29778@elte.hu>
	<1249378140.7924.168.camel@twins>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 04 Aug 2009 11:29:00 +0200

> On Tue, 2009-08-04 at 11:25 +0200, Ingo Molnar wrote:
>> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
>> 
>> > +static void load_perf_bfd_demangle(void)
>> > +{
>> > +	void *handle = dlopen("libbfd-2.19.51.0.2-17.fc11.so", RTLD_NOW);
>> 
>> Hm, this does not look like a very generic solution. Is there some 
>> way to do a library search to figure out the name? I guess a glob 
>> match on /usr/lib/libbfd*.so?
> 
> I'd simply go for libbfd.so and raise a bug report against fedora. A
> link archive named .so is just stupid.

It really isn't, I find it surprising why people are so up in
arms about this.  It's a quite common technique.

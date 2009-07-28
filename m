Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbZG1OSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbZG1OSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZG1OSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:18:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZG1OSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:18:16 -0400
Date: Tue, 28 Jul 2009 11:17:53 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to
	/etc/perfconfig/symbols.skip
Message-ID: <20090728141753.GI28349@ghostprotocols.net>
References: <20090728001041.GG28349@ghostprotocols.net> <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 27, 2009 at 08:58:08PM -0700, Ray Lee escreveu:
> On Mon, Jul 27, 2009 at 5:10 PM, Arnaldo Carvalho de
> Melo<acme@redhat.com> wrote:
> > This also paves the way to add more symbol lists to be filtered out,
> > spinlock anyone?
> 
> Generally, the way I've found is best to handle things like this is to either:
> 
> A. Have a fall-back list to use if the file isn't found, or
> B. Start with the fall-back list of symbols to filter, then add to
> them via /etc/... and ~/.perf/...
> 
> I like approaching things from the 'everything works even in a
> broken/hasty installation' point of view, and it's paid off for me.
> Sane defaults are a wonderfully useful thing.

While in general we agree with you, in this case the only problem would
be that we would see a few functions on idle systems, i.e. not something
catastrophic.

- Arnaldo

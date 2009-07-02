Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZGBGr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZGBGr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZGBGrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:47:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZGBGrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:47:21 -0400
Date: Thu, 2 Jul 2009 08:47:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090702064712.GA26690@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246514639.13293.40.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Per $subject, this patch set only supports for the LIVE kernel.  
> It adds support infrastructure for path discovery, load address 
> lookup, and symbol generation of live kernel modules.
> 
> TODO includes resurrection of live annotation in perf top, and 
> support for annotation and report generation of other than live 
> modules.  As the patch set sits, Perf top can generate symbols 
> from live binaries, but there's no live annotation capability yet.
> 
> patch1: perf_counter tools: Make symbol loading consistently return number of loaded symbols.
> patch2: perf_counter tools: Add infrastructure to support loading of kernel module symbols
> patch3: perf_counter tools: connect module support infrastructure to symbol loading infrastructure
> patch4: perf_counter tools: Enable kernel module symbol loading in tools
> 
> Comments and suggestions most welcome.

Looks very nice! I've applied it with a few minor stylistic fixlets 
and a tad more verbose changelogs.

I'm wondering about the next step: couldnt we somehow guess at the 
position of the vmlinux too, validate somehow that it corresponds to 
the kernel we are running - and then use it automatically and by 
default?

Plus, offline analysis would be nice as well i suspect - being able 
to look at profiles on a different box?

	Ingo

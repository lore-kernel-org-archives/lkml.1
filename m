Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZABS65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZABS65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbZABS6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:58:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbZABS6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:58:49 -0500
Date: Fri, 2 Jan 2009 19:58:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>, hpa@kernel.org,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cpuid.c fix style problems
Message-ID: <20090102185829.GA14249@elte.hu>
References: <1230721188.3738.2.camel@jaswinder.satnam> <84144f020812310501w4c64de85r9125cfacccc5ae97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812310501w4c64de85r9125cfacccc5ae97@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Wed, Dec 31, 2008 at 12:59 PM, Jaswinder Singh Rajput
> <jaswinder@infradead.org> wrote:
> >        cpu = iminor(file->f_path.dentry->d_inode);
> > -       if (cpu >= NR_CPUS || !cpu_online(cpu)) {
> > +       if (cpu >= num_possible_cpus() || !cpu_online(cpu)) {
> 
> How come you didn't convert the first part of the expression to use
> cpu_possible()?

i skipped this bit btw., as it got mooted by the cleanups in the cpumask 
and cpus4096 trees.

	Ingo

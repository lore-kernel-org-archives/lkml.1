Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYAEPKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYAEPKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYAEPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:10:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbYAEPJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:09:59 -0500
Date: Sat, 5 Jan 2008 16:09:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: little fix in 'include/asm-x86/topology.h'
Message-ID: <20080105150944.GA9595@elte.hu>
References: <200801042304.58071.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801042304.58071.mboton@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Miguel Botón <mboton.lkml@gmail.com> wrote:

> Before 'topology_32.h' and 'topology_64.h' were unified, topology 
> defines in a X86_64 kernel were declared if CONFIG_SMP was enabled. 
> Now, post unification, these same defines in a X86_64 kernel are only 
> being declared if CONFIG_NUMA and CONFIG_SMP are enabled.
> 
> This, for example, breaks 'perfmon_amd64.c' compilation.
> 
> This patch defines ENABLE_TOPO_DEFINE if this is a X86_64 kernel and 
> we have SMP support enabled.

hm, do you have a .config that fails to build?

	Ingo

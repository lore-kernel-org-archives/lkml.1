Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYI3HyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYI3HyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYI3HyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:54:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYI3HyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:54:06 -0400
Date: Tue, 30 Sep 2008 09:53:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch 2/2] x86: move prefill_possible_map calling early, fix,
	V2
Message-ID: <20080930075353.GA20241@elte.hu>
References: <20080929182756.4e33b06b@redhat.com> <20080929182942.68fbb4fb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929182942.68fbb4fb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> From: Chuck Ebbert <cebbert@redhat.com>
> 
> x86: move prefill_possible_map calling early, fix, V2
> 
> fix:
> 
> arch/x86/kernel/built-in.o: In function `setup_arch':
> : undefined reference to `prefill_possible_map'
> 
> Fix this by making prefill_possible_map() available even when
> CONFIG_HOTPLUG_CPU is not set. The function is needed so that
> the number of possible CPUs can be determined.
> 
> Tested on uniprocessor machine with CPU hotplug disabled.
> From boot log:
> Before: NR_CPUS: 512, nr_cpu_ids: 512, nr_node_ids 1
> After: NR_CPUS: 512, nr_cpu_ids: 1, nr_node_ids 1

applied to tip/x86/core, thanks Chuck! Made it a single delta patch, to 
ease backporting.

	Ingo

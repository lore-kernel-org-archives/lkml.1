Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXCFNV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXCFNV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXCFNV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:21:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53782 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXCFNVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:21:54 -0500
Date: Tue, 6 Mar 2007 14:21:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/8] Remove NR_CPUS from asm-generic/percpu.h
Message-ID: <20070306132138.GE9031@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain> <1173185592.4644.28.camel@localhost.localdomain> <1173185666.4644.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173185666.4644.30.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> I managed to get an error about NR_CPUS undefined after a make 
> allyesconfig.  Admittedly this was a patched kernel, but it's easy to 
> remove it and avoid the error in future even if it's OK at the moment.

> -extern unsigned long __per_cpu_offset[NR_CPUS];
> +extern unsigned long __per_cpu_offset[];

i'd much rather have us fix that include file dependency problem than to 
work it around by hiding the true dimension of the __per_cpu_offset 
array

	Ingo

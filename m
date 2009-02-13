Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbZBMMzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbZBMMzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZBMMy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:54:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbZBMMy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:54:56 -0500
Date: Fri, 13 Feb 2009 13:54:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: Fix xen_flush_tlb_others
Message-ID: <20090213125437.GE5483@elte.hu>
References: <4994BE06.4040006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4994BE06.4040006@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Ian Campbell <Ian.Campbell@citrix.com>
>
>    xen: Fix xen_flush_tlb_others
>       The commit
>        commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
>        Author: Rusty Russell <rusty@rustcorp.com.au>
>        Date:   Sat Jan 10 21:58:09 2009 -0800
>               x86: change flush_tlb_others to take a const struct cpumask
>       causes xen_flush_tlb_others to allocate a multicall and then issue 

applied to tip:x86/paravirt, thanks Jeremy!

	Ingo

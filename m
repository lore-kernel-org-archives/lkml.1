Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbXCEN4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbXCEN4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXCEN4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:56:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54172 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbXCEN4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:56:22 -0500
Date: Mon, 5 Mar 2007 14:48:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305134803.GA31327@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <20070305143437.GF22829@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305143437.GF22829@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > VDSO is only a problem if (1) the hypervisor wants to reserve the 
> > top virtual address space (CONFIG_PARAVIRT=y), and (2) the glibc is 
> > old and
> 
> It broke the boot even with native hardware, no hypervisor

yeah - i just sent the fix for that regression - by making 
CONFIG_COMPAT_VDSO usable again.

basically, we want to avoid all the compatibility mess that exists on 
the hypervisor side to enter the Linux kernel.

	Ingo

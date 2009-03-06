Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZCFPvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZCFPvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbZCFPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:51:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZCFPvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:51:03 -0500
Date: Fri, 6 Mar 2009 16:50:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: fix undefined linking reference of
	nx_enabled for 64 bit
Message-ID: <20090306155047.GA4623@elte.hu>
References: <1236354582.25265.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236354582.25265.1.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Subject: [PATCH] x86: fix undefined linking reference of nx_enabled for 64 bit
> 
>   LD      .tmp_vmlinux1
> arch/x86/mm/built-in.o: In function `init_memory_mapping':
> (.ref.text+0x73): undefined reference to `nx_enabled'
> make: *** [.tmp_vmlinux1] Error 1

yep - just fixed it and pushed out a new tip:master about 10 
minutes ago.

	Ingo

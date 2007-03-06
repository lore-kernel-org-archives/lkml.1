Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXCFNPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXCFNPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXCFNPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:15:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265AbXCFNPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:15:40 -0500
Date: Tue, 6 Mar 2007 14:15:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 6/8] Allow per-cpu variables to be page-aligned
Message-ID: <20070306131522.GC9031@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain> <1173185592.4644.28.camel@localhost.localdomain> <1173185666.4644.30.camel@localhost.localdomain> <1173185734.4644.32.camel@localhost.localdomain> <1173185827.4644.34.camel@localhost.localdomain> <1173185909.4644.36.camel@localhost.localdomain> <1173186021.4644.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173186021.4644.38.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Xen wants page-aligned GDT (and PDA must not cross a page-boundary, 
> but that doesn't happen at the moment since it's so close to start of 
> page).  Let's allow page-alignment in general for per-cpu data.
> 
> Because larger alignments can use more room, we increase the max 
> per-cpu memory to 64k rather than 32k: it's getting a little tight.

i recently needed page-aligned per-cpu data too for KVM-paravirt. Btw., 
what's the size increase of the native kernel?

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbXB1Iiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbXB1Iiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXB1Iiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:38:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbXB1Iix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:38:53 -0500
Date: Wed, 28 Feb 2007 09:32:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to pack and unpack pagetable entries
Message-ID: <20070228083203.GB8866@elte.hu>
References: <20070227081337.434798469@goop.org> <20070227081630.311681690@goop.org> <20070227100850.GA10827@elte.hu> <45E47DEF.70405@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E47DEF.70405@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1910]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> >> +#ifdef CONFIG_PARAVIRT
> >> +/* After pte_t, etc, have been defined */
> >> +#include <asm/paravirt.h>
> >> +#endif
> >>     
> >
> > hm - there's already a CONFIG_PARAVIRT conditional in 
> > asm-i386/paravirt.h.
> 
> Yes, but it happens after asm/paravirt.h has already included some 
> things, and it ends up causing problems.  paravirt.h still defines 
> various stub functions in the !CONFIG_PARAVIRT case, so it needs to do 
> the includes either way.

hm, it then needs to be fixed first, instead of adding to the mess.

	Ingo

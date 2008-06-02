Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbYFBLOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbYFBLOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYFBLOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:14:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbYFBLOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:14:17 -0400
Date: Mon, 2 Jun 2008 13:13:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
Message-ID: <20080602111339.GB18586@elte.hu>
References: <patchbomb.1212192268@localhost> <4deead25e96efc8ca783.1212192269@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4deead25e96efc8ca783.1212192269@localhost>
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

> +	/* Get the current pte state, but zero it out to make it
> +	   non-present, preventing the hardware from asynchronously
> +	   updating it. */

please use standard and consistent comment style, similar to:

> +/*
> + * Start a pte protection read-modify-write transaction, which
> + * protects against asynchronous hardware modifications to the pte.
> + * The intention is not to prevent the hardware from making pte
> + * updates, but to prevent any updates it may make from being lost.

	Ingo

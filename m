Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYABLpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYABLpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYABLpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:45:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYABLpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:45:24 -0500
Date: Wed, 2 Jan 2008 12:41:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on
	x86-64 (rev. 2)
Message-ID: <20080102114108.GA24329@elte.hu>
References: <200712302313.52483.rjw@sisk.pl> <20080102000222.GA2404@ucw.cz> <200801020023.58040.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801020023.58040.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > Document the fact that __save_processor_state() has to save all 
> > > CPU registers referred to by the kernel in case a different kernel 
> > > is used to load and restore a hibernation image containing it.
> > > 
> > > Sigend-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > ACK.
> 
> Thanks!
> 
> Ingo, can you please take this patch for 2.6.25 or should I forward it 
> to Len?

sure, applied it to x86.git. I've also zapped the cr8 elimination patch.

	Ingo

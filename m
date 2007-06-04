Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbXFDTMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbXFDTMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbXFDTMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:12:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350AbXFDTMj (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:12:39 -0400
Date: Mon, 4 Jun 2007 21:12:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604191229.GA12444@elte.hu>
References: <20070604173710.GR11166@waste.org> <20070604181151.GA1745@elte.hu> <20070604184224.GH11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604184224.GH11115@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Matt Mackall <mpm@selenic.com> wrote:

> > btw., does this only happen with lguest, or with other idle shells 
> > too?
> 
> Only noticed with lguest.

ah, so both the shell and the 'competing' CPU hog was running within the 
same lguest instance?

	Ingo

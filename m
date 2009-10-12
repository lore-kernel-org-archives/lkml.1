Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZJLIsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZJLIsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZJLIsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:48:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbZJLIsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:48:20 -0400
Date: Mon, 12 Oct 2009 10:47:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] perf build questions
Message-ID: <20091012084734.GA18098@elte.hu>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com> <1254818939.21044.120.camel@laptop> <20091006102626.8b4f7810.randy.dunlap@oracle.com> <20091006180551.GB11702@bombadil.infradead.org> <20091006110941.eebe58af.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006110941.eebe58af.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> All 64-bit userspace & kernel.  so that fails.  Thanks.

btw., i'm curious, what was/is your motivation for cross-building in 
that way? On a 64-bit system you really want a 64-bit perf binary - it's 
faster.

	Ingo

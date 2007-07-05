Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbXGEIzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbXGEIzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbXGEIy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:54:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbXGEIy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:54:56 -0400
Date: Thu, 5 Jul 2007 10:54:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
Message-ID: <20070705085434.GD3476@elte.hu>
References: <1183583529.9662.34.camel@johannes.berg> <20070705084538.GA3476@elte.hu> <1183625448.3818.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183625448.3818.6.camel@johannes.berg>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> Btw, do you have a tree you'll submit this through, or Oleg, or should 
> I send it to akpm after we sort out any further issues?

yep, would be nice if akpm could pick it up. (unless Peter wants to set 
up a lockdep git tree?) This should be merged into 2.6.23 early on.

	Ingo

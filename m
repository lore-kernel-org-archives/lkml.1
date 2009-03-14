Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZCNIzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZCNIzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZCNIzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:55:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbZCNIzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:55:11 -0400
Date: Sat, 14 Mar 2009 09:54:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, laijs@cn.fujitsu.com,
       pmarques@grupopie.com, srostedt@redhat.com, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] kallsyms, tracing: output more proper symbol name
Message-ID: <20090314085433.GA14513@elte.hu>
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu> <49B7B70F.5010908@grupopie.com> <49B876BB.50007@cn.fujitsu.com> <49B92B25.6020805@grupopie.com> <49BA06E2.7080807@cn.fujitsu.com> <49BA2704.9040404@cn.fujitsu.com> <20090313194013.GA23304@uranus.ravnborg.org> <20090313130722.1d92ad80.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313130722.1d92ad80.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Mar 2009 20:40:13 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > This patch puts symbols like "__irqentry_text_start" to the second
> > > aliased symbols. And a more proper symbol name becomes the first.
> > > 
> > > Aliased symbols mostly come from linker script. The solution is
> > > guessing "is this symbol defined in linker script", the symbols
> > > defined in linker script will not become the first aliased symbol.
> > > 
> > > And if symbols are found to be equal in this "linker script provided"
> > > criteria, symbols are sorted by the number of prefix underscores.
> > > 
> > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Looks good to me.
> > 
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> So... do we need this in 2.6.29?

no. This got raised in the context of new tracing changes queued 
up for 2.6.30.

	Ingo

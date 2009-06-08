Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZFHUyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZFHUyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 16:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZFHUy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 16:54:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbZFHUyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 16:54:25 -0400
Date: Mon, 8 Jun 2009 22:54:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, rusty@rustcorp.com.au, davem@davemloft.net
Subject: Re: [this_cpu_xx 04/11] Use this_cpu ops for network statistics
Message-ID: <20090608205406.GB13343@elte.hu>
References: <20090605191819.376530498@gentwo.org> <20090605191851.012334412@gentwo.org> <20090608112736.GL29447@sgi.com> <alpine.DEB.1.10.0906081649020.12271@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906081649020.12271@gentwo.org>
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


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 8 Jun 2009, Robin Holt wrote:
> 
> > > +	this_cpu_inc((net)->ct.stat->count)
> >
> > Why not put this on one line?
> > #define NF_CT_STAT_INC_ATOMIC(net, count)  this_cpu_inc((net)->ct.stat->count)
> 
> Would be more than 78 characters in a line.

I think you can ignore such types of warnings in general. I think 
checkpatch should be silent up to 90 chars or so, if there's not 
more than say 3 tabs in that line. (if there's a lot of tabs that 
means the indentation level is wrong.)

	Ingo

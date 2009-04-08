Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZDHLBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZDHLBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZDHLBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:01:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbZDHLBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:01:02 -0400
Date: Wed, 8 Apr 2009 13:00:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
	macros
Message-ID: <20090408110037.GD17321@elte.hu>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org> <20090406175918.c38654b2.akpm@linux-foundation.org> <1239066583.22733.258.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239066583.22733.258.camel@macbook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2009-04-06 at 17:59 -0700, Andrew Morton wrote:
> > 
> > Three days old?  Never been in linux-next afaict.
> > 
> > Please don't do that.
> 
> Sorry about that. There was some confusion about whether it was 
> going via Ingo's or my tree, and it ended up in neither. It 
> depended on certain things in Ingo's tree, so I couldn't easily 
> add it to my tree any earlier.

Well, they could have ended up in the x86 tree or in the IOMMU tree, 
but the patches were all very late and went through various review 
rounds with me so they had no chance to end up there in a finished 
state before the merge window.

I didnt mind you pushing them to Linus separately and gave an 
Acked-by for the bits and for that merge route, but all the usual 
protocols still have to be followed if you do that: review, testing, 
proper exposure.

	Ingo

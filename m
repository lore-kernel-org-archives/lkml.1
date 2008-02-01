Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbYBAN2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbYBAN2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbYBAN2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:28:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909AbYBAN2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:28:35 -0500
Date: Fri, 1 Feb 2008 14:28:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: PAE swapper_pg_dir needs to be page-sized
Message-ID: <20080201132821.GB11070@elte.hu>
References: <47A251E9.4050606@goop.org> <1201856044.3804.1.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201856044.3804.1.camel@cthulhu.hellion.org.uk>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> On Thu, 2008-01-31 at 14:55 -0800, Jeremy Fitzhardinge wrote: 
> > Xen currently needs swapper_pg_dir page aligned and sized.  This fixes
> > the second part of that...
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> 
> Acked-by: Ian Campbell <ijc@hellion.org.uk>

> >  # endif
> > +	.align PAGE_SIZE_asm		/* needs to be page-sized too */

thanks, applied. I'm wondering, where did we break that?

	Ingo

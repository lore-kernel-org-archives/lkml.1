Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZEIIbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZEIIbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZEIIbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:31:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZEIIba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:31:30 -0400
Date: Sat, 9 May 2009 10:30:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       riel@redhat.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
Message-ID: <20090509083048.GB3656@elte.hu>
References: <1241795429.28600.61.camel@penberg-laptop> <alpine.DEB.1.10.0905081127240.26361@qirst.com> <1241797341.28600.66.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241797341.28600.66.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, 2009-05-08 at 11:28 -0400, Christoph Lameter wrote:
> > On Fri, 8 May 2009, Pekka Enberg wrote:
> > 
> > > This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
> > > BUG_ON() calls.
> > 
> > Yirks this is not only early boot code. create_unique_id may be executed
> > whenever a slab is created.
> 
> Updated patch here:
> 
> Subject: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch converts SLUB early-boot code to use GFP_PANIC instead of BUG_ON().
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

thanks Pekka!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXK2Q0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXK2Q0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXK2Q0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:26:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbXK2Q0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:26:18 -0500
Date: Thu, 29 Nov 2007 17:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
Message-ID: <20071129162556.GA4268@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129105744.GI10577@elte.hu> <E1Ixlv9-0001rb-U7@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ixlv9-0001rb-U7@dorka.pomaz.szeredi.hu>
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
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > to get symbolic stack backdumps for the wakeup points, and add 
> > trace_special_sym() calls to generate extra stackdump entries at 
> > arbitrary places. schedule() does not have it right now - it might 
> > make sense to add it.
> 
> OK, this helped.
> 
> It looks like the delays are caused by the page allocator, and not 
> UML.  Which is good news, because I'm supposed to understand memory 
> management better than scheduling.

heh :-) Scheduling isnt hard either - and looking at traces (especially 
with mcount_enabled=1) certainly helps.

	Ingo

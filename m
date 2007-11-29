Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXK2T1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXK2T1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXK2T0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:26:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbXK2T0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:26:52 -0500
Date: Thu, 29 Nov 2007 20:26:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
Message-ID: <20071129192635.GE5238@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129105744.GI10577@elte.hu> <E1Ixlv9-0001rb-U7@dorka.pomaz.szeredi.hu> <20071129162556.GA4268@elte.hu> <E1Ixnla-0002Ey-By@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ixnla-0002Ey-By@dorka.pomaz.szeredi.hu>
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

> > heh :-) Scheduling isnt hard either - and looking at traces 
> > (especially with mcount_enabled=1) certainly helps.
> 
> I still don't know what mcount_enabled=1 should do.  I didn't see any 
> difference in the trace after enabling it.

if you build with CONFIG_FUNCTION_TRACING then you should see a trace of 
*every* function call done within the kernel. Warning: reading it can be 
very addictive ;-)

	Ingo

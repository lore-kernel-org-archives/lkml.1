Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXK2SGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXK2SGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763906AbXK2SFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:05:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39635 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763887AbXK2SFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:05:52 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071129162556.GA4268@elte.hu> (message from Ingo Molnar on Thu,
	29 Nov 2007 17:25:56 +0100)
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129105744.GI10577@elte.hu> <E1Ixlv9-0001rb-U7@dorka.pomaz.szeredi.hu> <20071129162556.GA4268@elte.hu>
Message-Id: <E1Ixnla-0002Ey-By@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Nov 2007 19:05:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > to get symbolic stack backdumps for the wakeup points, and add 
> > > trace_special_sym() calls to generate extra stackdump entries at 
> > > arbitrary places. schedule() does not have it right now - it might 
> > > make sense to add it.
> > 
> > OK, this helped.
> > 
> > It looks like the delays are caused by the page allocator, and not 
> > UML.  Which is good news, because I'm supposed to understand memory 
> > management better than scheduling.
> 
> heh :-) Scheduling isnt hard either - and looking at traces (especially 
> with mcount_enabled=1) certainly helps.

I still don't know what mcount_enabled=1 should do.  I didn't see any
difference in the trace after enabling it.

Miklos

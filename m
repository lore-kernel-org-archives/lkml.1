Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXJWJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXJWJSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXJWJSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:18:13 -0400
Received: from mx10.go2.pl ([193.17.41.74]:47557 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbXJWJSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:18:11 -0400
Date: Tue, 23 Oct 2007 11:21:27 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Maciej W\. Rozycki" <macro@linux-mips.org>,
       Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flush_work_sync vs. flush_scheduled_work Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
Message-ID: <20071023092127.GB1847@ff.dom.local>
References: <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl> <20071016062108.GB1000@ff.dom.local> <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl> <20071017085809.GA1658@ff.dom.local> <20071018063157.GA1694@ff.dom.local> <20071018070531.GA2065@ff.dom.local> <20071018154819.GA425@tv-sign.ru> <20071019075014.GA1765@ff.dom.local> <20071022061143.GA973@ff.dom.local> <20071022180259.GA967@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022180259.GA967@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 10:02:59PM +0400, Oleg Nesterov wrote:
...
> If this work doesn't rearm itself - yes. (otherwise, the same ->func
> can run twice _at the same time_)
> 
> But again, in this case wait_on_work() after try_to_grab_pending() == 1
> doesn't block, so we can just do
> 
> 	if (cancel_work_sync(w))
> 		w->func();
> 

...but, if it were run just before work_clear_pending()?

Jarek P.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbXJSR7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbXJSR7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934989AbXJSR6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:58:40 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:52737 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbXJSR6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:58:38 -0400
Date: Fri, 19 Oct 2007 18:58:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
In-Reply-To: <20071019143921.GB2598@ff.dom.local>
Message-ID: <Pine.LNX.4.64N.0710191852140.13279@blysk.ds.pg.gda.pl>
References: <20071015125301.GC3015@ff.dom.local>
 <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl> <20071016062108.GB1000@ff.dom.local>
 <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl> <20071017085809.GA1658@ff.dom.local>
 <Pine.LNX.4.64N.0710171221510.28993@blysk.ds.pg.gda.pl>
 <Pine.LNX.4.64N.0710191229510.13279@blysk.ds.pg.gda.pl> <20071019143921.GB2598@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Jarek Poplawski wrote:

> Actually I'm not convinced with this explanation. It seems to me that
> since there are such serious locking problems (especially with rntl),
> there could be once more considered a private workqueue. You've
> written earlier about being a lonely user of this code. But, since

 Well, this will change eventually when I submit the patch for Broadcom 
SiByte platforms so that sb1250-mac.c will be able to request an interrupt 
for the PHYs.  All the infrastructure is in place except from platform 
code to configure the SOC's GPIO line used for the interrupt input (when 
applicable) and let the driver know what the line actually is.

> Benjamin offered his help with changing to mutexes, which looks like
> very reasonable idea to me (probably I miss most of the points...),
> maybe it's very good opportunity to both: make this code better and
> double the user base! I'm interested in looking for such solution
> if Benjamin thinks there could be too few problems for him... So,
> let somebody tell us what could be wrong with this idea?

 I do not object and can certainly cooperate, but cannot make it a high 
priority work for me at the moment -- sorry.

  Maciej

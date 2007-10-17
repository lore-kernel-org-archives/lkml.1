Return-Path: <linux-kernel-owner+w=401wt.eu-S1765493AbXJQJGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765493AbXJQJGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQJGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:06:44 -0400
Received: from mx12.go2.pl ([193.17.41.142]:56672 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753074AbXJQJGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:06:43 -0400
Date: Wed, 17 Oct 2007 11:09:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: "Maciej W\. Rozycki" <macro@linux-mips.org>
Cc: Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
Message-ID: <20071017090946.GB1658@ff.dom.local>
References: <20071015125301.GC3015@ff.dom.local> <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl> <20071016062108.GB1000@ff.dom.local> <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl> <20071017085809.GA1658@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017085809.GA1658@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 10:58:09AM +0200, Jarek Poplawski wrote:
...
> 5) phy_stop_interrupts(): maybe I miss something, but it seems
> phy_stop() is required before this, so maybe there should be a
> comment on this?
> 
> 6) phy_stop_interrupts(): if I'm not wrong with #3 calling

Should be:
  6) phy_stop_interrupts(): if I'm not wrong with #5 calling

Jarek P.

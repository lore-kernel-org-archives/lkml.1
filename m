Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZAUIdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZAUIdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761622AbZAUIdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:33:15 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:18634 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760835AbZAUIdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:33:14 -0500
Date: Wed, 21 Jan 2009 17:30:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Adrian McMenamin <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
       dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
Message-ID: <20090121083011.GB14537@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Guennadi Liakhovetski <lg@denx.de>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
	dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
	Johannes Weiner <hannes@cmpxchg.org>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com> <1232488507.6794.8.camel@localhost.localdomain> <20090121033951.GB14094@linux-sh.org> <20090121081118.GA14537@linux-sh.org> <Pine.LNX.4.64.0901210928010.4407@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901210928010.4407@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 09:29:39AM +0100, Guennadi Liakhovetski wrote:
> Nitpick:
> 
> On Wed, 21 Jan 2009, Paul Mundt wrote:
> 
> > +	/*
> > +	 * Memory was found in the per-device arena.
> > +	 */
> 
> s/arena/area/ ?
> 
That was in the original, I'll fix it up before sending it off.

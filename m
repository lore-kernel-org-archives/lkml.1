Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYHFWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYHFWJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYHFWJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:09:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:52178 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYHFWJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:09:11 -0400
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20080806.141920.30577822.davem@davemloft.net>
References: <20080806.003536.204220123.davem@davemloft.net>
	 <20080806084329.9d7e6d50.akpm@linux-foundation.org>
	 <20080806.141920.30577822.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 08:08:22 +1000
Message-Id: <1218060502.24157.239.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 14:19 -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 6 Aug 2008 08:43:29 -0700
> 
> > On Wed, 06 Aug 2008 00:35:36 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > 
> > > [ Andrew/Ben, this fixes the bootup hang we were talking about
> > >   the other day. ]
> > > 
> > > radeonfb: Fix copyarea for R300 and later.
> > > 
> > > For current chips we need to make sure the DSTCACHE_CTLSTAT and
> > > WAIT_UNTIL registers are properly setup.  If not, a sequence of
> > > copyarea operations can result in the 2D raster processor
> > > hanging.
> > 
> > Neato.  This can be backported to -stable without also backporting your
> > recent radeon-misc-corrections.patch, I assume?
> 
> Yes, it can.
> 
> I discussed the patch with Ben earlier and he wants to add the
> same register writes to the solidfill code as well.

That and the flush code for when we're about to manually hit the fb.

I'll send a patch later today.

Ben.



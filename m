Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbYHFV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbYHFV3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbYHFVTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:19:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763484AbYHFVTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:19:20 -0400
Date: Wed, 06 Aug 2008 14:19:20 -0700 (PDT)
Message-Id: <20080806.141920.30577822.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080806084329.9d7e6d50.akpm@linux-foundation.org>
References: <20080806.003536.204220123.davem@davemloft.net>
	<20080806084329.9d7e6d50.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 6 Aug 2008 08:43:29 -0700

> On Wed, 06 Aug 2008 00:35:36 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> 
> > [ Andrew/Ben, this fixes the bootup hang we were talking about
> >   the other day. ]
> > 
> > radeonfb: Fix copyarea for R300 and later.
> > 
> > For current chips we need to make sure the DSTCACHE_CTLSTAT and
> > WAIT_UNTIL registers are properly setup.  If not, a sequence of
> > copyarea operations can result in the 2D raster processor
> > hanging.
> 
> Neato.  This can be backported to -stable without also backporting your
> recent radeon-misc-corrections.patch, I assume?

Yes, it can.

I discussed the patch with Ben earlier and he wants to add the
same register writes to the solidfill code as well.

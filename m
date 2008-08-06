Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYHFWNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYHFWNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYHFWKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:10:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:52198 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYHFWKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:10:11 -0400
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20080806084329.9d7e6d50.akpm@linux-foundation.org>
References: <20080806.003536.204220123.davem@davemloft.net>
	 <20080806084329.9d7e6d50.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 08:09:29 +1000
Message-Id: <1218060569.24157.241.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 08:43 -0700, Andrew Morton wrote:
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

I'd rather do both. The first one affects the bits used by the second.

Ben.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYGXU6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYGXU6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYGXU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:58:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56182
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbYGXU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:58:10 -0400
Date: Thu, 24 Jul 2008 13:58:10 -0700 (PDT)
Message-Id: <20080724.135810.235355036.davem@davemloft.net>
To: penberg@cs.helsinki.fi
Cc: akpm@linux-foundation.org, kaber@trash.net, mingo@elte.hu,
       herbert@gondor.apana.org.au, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, rjw@sisk.pl,
       ilpo.jarvinen@helsinki.fi, davej@redhat.com, clip2@gmx.de,
       vegard.nossum@gmail.com
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
 pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216925744.12392.1.camel@penberg-laptop>
References: <1216906476.12021.4.camel@penberg-laptop>
	<20080724115127.6cfbb616.akpm@linux-foundation.org>
	<1216925744.12392.1.camel@penberg-laptop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 24 Jul 2008 21:55:44 +0300

> On Thu, 2008-07-24 at 11:51 -0700, Andrew Morton wrote:
> > Sure.  Or Patrick can do so and it can be merged via the net tree.
> > 
> > Ingo, did this patch actually fix something over there?
> 
> Apparently it didn't but it did fix Dieter's problem:
> 
> http://lkml.org/lkml/2008/7/24/337
> 
> Dieter, can we add a Tested-by tag from you to this patch?

Patrick will toss it my way, and it'll get integrated
via net-2.6 as a result.

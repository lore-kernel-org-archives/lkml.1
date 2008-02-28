Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbYB1TdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbYB1TdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761662AbYB1TcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:32:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44475
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762836AbYB1TcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:32:17 -0500
Date: Thu, 28 Feb 2008 11:32:16 -0800 (PST)
Message-Id: <20080228.113216.08837251.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: Daniel.Beschorner@facton.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: zlib oops with ipcomp in 2.6.24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080228193019.GA18514@gondor.apana.org.au>
References: <20080228175011.GA17185@gondor.apana.org.au>
	<20080228.112355.15717375.davem@davemloft.net>
	<20080228193019.GA18514@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 29 Feb 2008 03:30:20 +0800

> On Thu, Feb 28, 2008 at 11:23:55AM -0800, David Miller wrote:
> > 
> > The xfrm output lockless stuff is only in 2.6.25, so
> > we should not need this for -stable right?
> 
> Actually this particular bug is in 2.6.24 too so we need it
> there.

Ok, thanks, I'll queue it up for 2.6.24-stable then.

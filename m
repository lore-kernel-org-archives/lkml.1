Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZBVHxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZBVHxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 02:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZBVHx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 02:53:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45524
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZBVHx0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 02:53:26 -0500
Date: Sat, 21 Feb 2009 23:53:08 -0800 (PST)
Message-Id: <20090221.235308.172360407.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: herbert@gondor.apana.org.au, jeff.chua.linux@gmail.com, rjw@sisk.pl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0902212042420.20526@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0902091513190.31742@wrl-59.cs.helsinki.fi>
	<20090221132424.GA28861@gondor.apana.org.au>
	<Pine.LNX.4.64.0902212042420.20526@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Sat, 21 Feb 2009 20:54:11 +0200 (EET)

> On Sat, 21 Feb 2009, Herbert Xu wrote:
> 
> > On Mon, Feb 09, 2009 at 03:28:09PM +0200, Ilpo Järvinen wrote:
> > >
> > > Yes, that should work too except the gcc catchable typo.
> > 
> > Thanks, so let's try again for net-next:
> > 
> > tcp: Always set urgent pointer if it's beyond snd_nxt
 ...
> I thought this through already at the last time... so I think it really 
> should work in all cases I could think of (including the below window 
> probes whose existance is not very obvious before they bite back :-)):
> 
> Acked-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> 
> But I mostly agree with Linus that URG is legacy that would be good
> to just deprecate instead of trying to "fix" it.

Sure, but I'll give Herbert one more chance :-)

Applied to net-next-2.6

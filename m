Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbXFRJfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbXFRJfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXFRJfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:35:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39548
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbXFRJfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:35:02 -0400
Date: Mon, 18 Jun 2007 02:35:20 -0700 (PDT)
Message-Id: <20070618.023520.102546505.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
References: <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu>
	<20070618.021813.105401188.davem@davemloft.net>
	<E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 11:29:52 +0200

> > > And is anyone working on a better patch?
> > 
> > I have no idea.
> > 
> > > Those patches aren't "bad" in the correctness sense.  So IMO any one
> > > of them is better, than having that bug in there.
> > 
> > You're adding a very serious performance regression, which is
> > about as bad as the bug itself.
> 
> No, correctness always trumps performance.

To a point.  There is no black and white in this world.

> Lost packets on an AF_UNIX socket are _unexceptable_, and this is
> definitely not a theoretical problem.

A lot of people will consider having all of their AF_UNIX sockets on
their 64 cpu system just stop when garbage collection runs to be
unacceptable as well.

Secondarily, this bug has been around for years and nobody noticed.
The world will not explode if this bug takes a few more days or
even a week to work out.  Let's do it right instead of ramming
arbitrary turds into the kernel.

> Do you want me to send the patch to Andrew instead?  His attitude
> towards bugfixes is rather better ;)

When I explain the ramifications of your patch to him, I'm pretty
sure he'll agree with me.

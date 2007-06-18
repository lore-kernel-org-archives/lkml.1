Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbXFRJbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbXFRJbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbXFRJai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:30:38 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:42912 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760958AbXFRJag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:30:36 -0400
To: davem@davemloft.net
CC: akpm@linux-foundation.org, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20070618.021813.105401188.davem@davemloft.net> (message from
	David Miller on Mon, 18 Jun 2007 02:18:13 -0700 (PDT))
Subject: Re: [PATCH] fix race in AF_UNIX
References: <E1I0BzQ-0006gZ-00@dorka.pomaz.szeredi.hu>
	<20070618.005711.21897961.davem@davemloft.net>
	<E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu> <20070618.021813.105401188.davem@davemloft.net>
Message-Id: <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 11:29:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > And is anyone working on a better patch?
> 
> I have no idea.
> 
> > Those patches aren't "bad" in the correctness sense.  So IMO any one
> > of them is better, than having that bug in there.
> 
> You're adding a very serious performance regression, which is
> about as bad as the bug itself.

No, correctness always trumps performance.  Lost packets on an AF_UNIX
socket are _unexceptable_, and this is definitely not a theoretical
problem.

And BTW my second patch does _not_ have the performance problems you
are arguing about, it's just plain ugly.  But hey, if you can't live
with ugly code, go and fix it.

> It can wait for a more appropriate fix.

Now _please_ be a bit more constructive.

Do you want me to send the patch to Andrew instead?  His attitude
towards bugfixes is rather better ;)

Miklos

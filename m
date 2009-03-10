Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZCJLYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZCJLYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZCJLYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:24:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56859
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755475AbZCJLYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:24:31 -0400
Date: Tue, 10 Mar 2009 04:24:17 -0700 (PDT)
Message-Id: <20090310.042417.242564481.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: stoyboyker@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 03/25] [net] BUG to BUG_ON changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090310102355.GB2248@x200.localdomain>
References: <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
	<1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
	<20090310102355.GB2248@x200.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 10 Mar 2009 13:23:55 +0300

> On Tue, Mar 10, 2009 at 12:10:28AM -0500, Stoyan Gaydarov wrote:
> > --- a/drivers/net/pppol2tp.c
> > +++ b/drivers/net/pppol2tp.c
> > @@ -1222,8 +1222,7 @@ static void pppol2tp_tunnel_closeall(struct pppol2tp_tunnel *tunnel)
> >  	struct pppol2tp_session *session;
> >  	struct sock *sk;
> >  
> > -	if (tunnel == NULL)
> > -		BUG();
> > +	BUG_ON(tunnel == NULL);
> 
> NAK, should be deleted, and kernel will oops anyway.

I think in situations such as this, where someone is trying to rid the
tree of an interface (where an exactly equivalent alternative
expression exists) so it can be deleted, it is absolutely unreasonable
to ask them to make non-trivial transformations like you are
requesting on top of what can already be a quite daunting task.

Please rescind your NACK, thanks.

This is the kind of NACK which makes me absolutely furious when I try
to contribute to projects other than the kernel.  So please don't make
the kernel suck as much as those projects do.  It's a deterrant to
contributors.

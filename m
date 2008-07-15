Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYGOWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYGOWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYGOWpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:45:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54890
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754931AbYGOWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:45:05 -0400
Date: Tue, 15 Jul 2008 15:45:04 -0700 (PDT)
Message-Id: <20080715.154504.63796024.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: jeff@garzik.org, torvalds@linux-foundation.org, tytso@mit.edu,
       david@lang.hm, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216161752.26991.61.camel@shinybook.infradead.org>
References: <1216157061.26991.41.camel@shinybook.infradead.org>
	<20080715.144720.66126410.davem@davemloft.net>
	<1216161752.26991.61.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 15 Jul 2008 15:42:32 -0700

> On Tue, 2008-07-15 at 14:47 -0700, David Miller wrote:
> > From: David Woodhouse <dwmw2@infradead.org>
> > Date: Tue, 15 Jul 2008 14:24:21 -0700
> > 
> > > Kernel 2.6.15 with ancient userland. You update to 2.6.16, which
> > > includes commit 5433383e ('convert qla2xxx to request_firmware()').
> > > 
> > > Same problem?
> > 
> > For the record I did get burnt by that one and I did make a huge stink
> > about it.
> > 
> > I used to be able to avoid initrd entirely on every single one of my
> > boxes, even my machines with qla2xxx based root filesystems, and that
> > changeset basically meant the end of that.
> 
> Until now. The only significant _generic_ change that just went into
> Linus' kernel is the fact that you can now build that firmware _into_
> your kernel, and you can boot qla2xxx without an initrd again.

That's great.

Even better would be if the qla2xxx firmware was the tree like it used
to be too.  Then it truly would be fully back to how things used to be.



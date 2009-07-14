Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZGNUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZGNUPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZGNUPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:15:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42740
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbZGNUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:15:48 -0400
Date: Tue, 14 Jul 2009 13:15:52 -0700 (PDT)
Message-Id: <20090714.131552.07104766.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090714211226.6d653016@lxorguk.ukuu.org.uk>
References: <20090714203123.0ab1f7b8@lxorguk.ukuu.org.uk>
	<20090714.123405.181074517.davem@davemloft.net>
	<20090714211226.6d653016@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 14 Jul 2009 21:12:26 +0100

> On Tue, 14 Jul 2009 12:34:05 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
>> At a minimum it likely needs to be added to the -stable trees.
> 
> No - the fix that needs to be in the stable trees is the one removing the
> bogus tty->low_latency settings. The standard tty layer blows up in all
> sorts of other ways with these driver bugs and I thought they'd been
> pushed back into -stable. Will check with GregKH as I think they went via
> his tree.

Understood.

I've reverted this change from the net-2.6 tree, thanks for
explaining.

Linus, please pull, this has been sorted out.

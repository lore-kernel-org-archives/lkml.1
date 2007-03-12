Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXCLUxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXCLUxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbXCLUxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:53:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43895
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932203AbXCLUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:53:13 -0400
Date: Mon, 12 Mar 2007 13:53:11 -0700 (PDT)
Message-Id: <20070312.135311.71086996.davem@davemloft.net>
To: jarkao2@o2.pl
Cc: amit2030@gmail.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Removal of multipath cached (was Re: [PATCH] [REVISED]
 net/ipv4/multipath_wrandom.c: check kmalloc() return value.)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070312115137.GA3270@ff.dom.local>
References: <20070308.232908.92582631.davem@davemloft.net>
	<20070312115137.GA3270@ff.dom.local>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@o2.pl>
Date: Mon, 12 Mar 2007 12:51:37 +0100

> But until then it'll unnecessarily spoil linux opinion as regards
> stability and waste time of developers to check error messages.
> So, maybe it's less evil to check those NULLs where possible and add
> some WARN_ONs here and there...

It's a crash either way, so zero improvement.

And _THIS_ is my big problem with the multi-path cached code in the
kernel.

NOBODY wants to step up and fix the code, but people refuse to let it
get removed from the tree.  That is totally unacceptable, so I'm going
to FIX THIS.

I'm going to FIX IT by saying that if nobody steps up to the plate to
fix the multipath cached code by 2.6.23 IT IS GONE forver.

And there is absolutely no negotiations about this, I've held back on
this for nearly 2 years, and nothing has happened, this code is not
maintained, nobody cares enough to fix the bugs, and even no
distributions enable it because it causes crashes.

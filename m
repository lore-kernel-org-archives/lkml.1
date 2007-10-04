Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbXJDUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbXJDUvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbXJDUvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:51:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45454
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757269AbXJDUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:51:14 -0400
Date: Thu, 04 Oct 2007 13:51:13 -0700 (PDT)
Message-Id: <20071004.135113.48807663.davem@davemloft.net>
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: Vague maybe ppp-related panic report for 2.6.23-rc9
From: David Miller <davem@davemloft.net>
In-Reply-To: <ada4ph6da05.fsf@cisco.com>
References: <ada4ph6da05.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 04 Oct 2007 11:12:42 -0700

> Sorry for the lack of detail -- I've just switched to running in the
> console so if I can provoke the crash again I'll get a little more
> info.  I just wanted to mention this in case someone has seen
> something similar or has any good ideas about how to capture debugging
> output on a laptop (when I'm not home and have no other boxes handy).

I don't want to jump the gun on the analysis but it just might
be the packet sharing fixes Herbert put in a short time ago.

What you could do is go back to say rc2 and see if you still get
the panics, then bisect from there to narrow it down.

If rc2 still gives the panic, it's something else, perhaps device
specific.

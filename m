Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYJaJwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYJaJwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYJaJwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:52:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38429
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYJaJwY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:52:24 -0400
Date: Fri, 31 Oct 2008 02:51:59 -0700 (PDT)
Message-Id: <20081031.025159.51432990.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: shemminger@vyatta.com, zbr@ioremap.net, rjw@sisk.pl, mingo@elte.hu,
       s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, efault@gmx.de,
       akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0810311119510.7072@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0810302047030.22084@wrl-59.cs.helsinki.fi>
	<20081031.005219.141937694.davem@davemloft.net>
	<Pine.LNX.4.64.0810311119510.7072@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Fri, 31 Oct 2008 11:40:16 +0200 (EET)

> Let me remind that it is just a single process, so no ping-pong & other 
> lock related cache effects should play any significant role here, no? (I'm 
> no expert though :-)).

Not locks or ping-pongs perhaps, I guess.  So it just sends and
receives over a socket, implementing both ends of the communication
in the same process?

If hash chain conflicts do happen for those 2 sockets, just traversing
the chain 2 entries deep could show up.

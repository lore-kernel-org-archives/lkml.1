Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZGNTeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZGNTeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZGNTeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:34:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38873
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbZGNTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:34:01 -0400
Date: Tue, 14 Jul 2009 12:34:05 -0700 (PDT)
Message-Id: <20090714.123405.181074517.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090714203123.0ab1f7b8@lxorguk.ukuu.org.uk>
References: <20090714.122704.21107059.davem@davemloft.net>
	<20090714203123.0ab1f7b8@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 14 Jul 2009 20:31:23 +0100

>> 8) Locking fix in TTY based networking drivers, from Ralf Baechle.
> 
> I thought we had established that this one was wrong following further
> discussion. The tty drivers that were calling up from IRQ handlers have
> been fixed by the cull of bogus tty->low_latency setting.

Where was this change made?

At a minimum it likely needs to be added to the -stable trees.

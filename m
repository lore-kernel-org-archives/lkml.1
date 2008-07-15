Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbYGOCT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbYGOCT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGOCTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:19:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37287
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754108AbYGOCTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:19:49 -0400
Date: Mon, 14 Jul 2008 19:19:49 -0700 (PDT)
Message-Id: <20080714.191949.121577785.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
References: <20080714165956.7fe2d4ee@infradead.org>
	<487C0365.5030203@garzik.org>
	<alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Jul 2008 19:13:16 -0700 (PDT)

> On Mon, 14 Jul 2008, Jeff Garzik wrote:
> > 
> > IMO the newly added /inability/ to build firmware into kernel modules is a
> > clear regression.
> 
> IMO you're being stupid.
> 
> How about explainign why it makes any difference what-so-ever?

Just like Jeff, I think it does.

> If you can load the module, you can load the firmware. Claiming anything 
> else is just _stupid_.

It's about having one foo.ko file that is self contained.

We've always been able to do that.

Just like how when module support was added to the kernel, and we
could still build everything statically into one kernel image if we
wanted to, we likewise should still be able to get everything
necessary for a driver module into a single foo.ko file.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYGUBOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYGUBOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYGUBOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:14:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36831
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755314AbYGUBOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:14:40 -0400
Date: Sun, 20 Jul 2008 18:14:40 -0700 (PDT)
Message-Id: <20080720.181440.122144107.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721010952.GA4822@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
	<20080720.180304.51601407.davem@davemloft.net>
	<20080721010952.GA4822@martell.zuzino.mipt.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 21 Jul 2008 05:09:52 +0400

> > > > This is the main networking merge for 2.6.27
> 
> Looks like multiqueue changes broken netconsole (it remains silent).

Can you dig a little bit deeper into this one?  It ought to
work fine.

Thanks.

> Also, I had to enable CONFIG_NET_SCHED=y, otherwise it wouldn't link:

I just pushed Linus a fix for that, Stephen Rothwell noticed it
too.

> And finally, boot process hangs after TCP cubic is initialized.

That very much should not happen.  Can you turn on initcall
tracing so we can see where that is happening exactly?

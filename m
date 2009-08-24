Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZHXF7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZHXF7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 01:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZHXF7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 01:59:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53840
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbZHXF7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 01:59:00 -0400
Date: Sun, 23 Aug 2009 22:59:12 -0700 (PDT)
Message-Id: <20090823.225912.87554943.davem@davemloft.net>
To: Dongdong.deng@windriver.com
Cc: nico@cam.org, mpm@selenic.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: [PATCH] [net] smc91x: let smc91x work well under netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <1251085351.6588.21.camel@dengdd-desktop>
References: <1250862005.24178.28.camel@dengdd-desktop>
	<alpine.LFD.2.00.0908211304000.6044@xanadu.home>
	<1251085351.6588.21.camel@dengdd-desktop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: DDD <Dongdong.deng@windriver.com>
Date: Mon, 24 Aug 2009 11:42:31 +0800

> The NETPOLL requires that interrupts remain disabled in its callbacks.
> 
> Using *_irq_save()/irq_restore() to replace *_irq_disable()/irq_enable()
> functions in NETPOLL's callbacks of smc91x, so that it doesn't enable
> interrupts when already disabled, and kgdboe/netconsole would work
> properly over smc91x.
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> Acked-by: Nicolas Pitre <nico@cam.org>

Applied, thanks.

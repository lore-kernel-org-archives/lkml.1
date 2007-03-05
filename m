Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXCEVbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXCEVbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933601AbXCEVbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:31:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40830
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933593AbXCEVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:31:03 -0500
Date: Mon, 05 Mar 2007 13:30:59 -0800 (PST)
Message-Id: <20070305.133059.08323813.davem@davemloft.net>
To: jan.altenberg@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile error in latest git
From: David Miller <davem@davemloft.net>
In-Reply-To: <1173092888.3417.11.camel@bender.tec.linutronix.de>
References: <1173092888.3417.11.camel@bender.tec.linutronix.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Altenberg <jan.altenberg@linutronix.de>
Date: Mon, 05 Mar 2007 12:08:08 +0100

> I recognized a compile error in latest git:
> 
> /here/workdir/git/drivers/net/gianfar.c: In function `gfar_vlan_rx_kill_vid':
> /here/workdir/git/drivers/net/gianfar.c:1135: error: structure has no member named `vgrp'
 ...
> Patch is attached.
> 
> Signed-off-by: Jan Altenberg <jan@linutronix.de>

Thanks for the fix, patch applied.

I did do an allmodconfig build to try and avoid breakage like
that, but alas gianfar only is offered on certain powerpc
systems in the kernel config :-/

Thanks again.

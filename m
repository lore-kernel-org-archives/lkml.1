Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZAJBDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZAJBDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZAJBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:02:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38804
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755043AbZAJBC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:02:58 -0500
Date: Fri, 09 Jan 2009 17:02:58 -0800 (PST)
Message-Id: <20090109.170258.169849917.davem@davemloft.net>
To: parag.lkml@gmail.com
Cc: shemminger@vyatta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix net/irda build breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901091829270.21215@localhost.localdomain>
References: <alpine.LFD.2.00.0901091829270.21215@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Parag Warudkar <parag.lkml@gmail.com>
Date: Fri, 9 Jan 2009 18:30:58 -0500 (EST)

> commit af0490810cfa159b4894ddecfc5eb2e4432fb976 breaks build for net/irda -
> 
> drivers/net/irda/donauboe.c: In function 'toshoboe_interrupt':
> drivers/net/irda/donauboe.c:1197: error: 'struct toshoboe_cb' has no member named 'stats'
> drivers/net/irda/donauboe.c:1201: error: 'struct toshoboe_cb' has no member named 'stats'
> drivers/net/irda/donauboe.c:1283: error: 'struct toshoboe_cb' has no member named 'stats'
> make[3]: *** [drivers/net/irda/donauboe.o] Error 1
> make[2]: *** [drivers/net/irda] Error 2
> 
> Fix this.
> 
> Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

Already fixed in the net-2.6 GIT tree, but thanks.

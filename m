Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbZD3Dbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbZD3Dbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZD3Db0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:31:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41032
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZD3DbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:31:25 -0400
Date: Wed, 29 Apr 2009 20:31:18 -0700 (PDT)
Message-Id: <20090429.203118.180924014.davem@davemloft.net>
To: jeff.chua.linux@gmail.com
Cc: torvalds@linux-foundation.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       dada1@cosmosbay.com, zbr@ioremap.net, peterz@infradead.org,
       jarkao2@gmail.com, paulus@samba.org, paulmck@linux.vnet.ibm.com,
       kaber@trash.net, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: [PATCH] netfilter: revised locking for x_tables
From: David Miller <davem@davemloft.net>
In-Reply-To: <b6a2187b0904292026k7d6107a7vcdc761d4149f40aa@mail.gmail.com>
References: <alpine.LFD.2.00.0904280954500.22156@localhost.localdomain>
	<20090428.223708.168741998.davem@davemloft.net>
	<b6a2187b0904292026k7d6107a7vcdc761d4149f40aa@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Chua <jeff.chua.linux@gmail.com>
Date: Thu, 30 Apr 2009 11:26:40 +0800

> On Wed, Apr 29, 2009 at 1:37 PM, David Miller <davem@davemloft.net> wrote:
>> I've applied this, thanks everyone!
> 
> I see the patch is already in Linus's tree that I just git pulled.
> Tested for 200 iptables rules ... as fast as before the slow down.
> 
> real    0m0.211s
> user    0m0.060s
> sys     0m0.144s
> 
> Thank you all for fixing this bug!

Thanks for testing.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765Ab0A0Etb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0A0Etb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 23:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696Ab0A0Eta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 23:49:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43999
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680Ab0A0Eta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 23:49:30 -0500
Date: Tue, 26 Jan 2010 20:49:42 -0800 (PST)
Message-Id: <20100126.204942.44952742.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       ron.mercer@qlogic.com, leitao@linux.vnet.ibm.com
Subject: Re: linux-next: net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100127131827.6aea9bf5.sfr@canb.auug.org.au>
References: <20100127131827.6aea9bf5.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Jan 2010 13:18:27 +1100

> Hi Dave,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/net/qlge/qlge_main.c: In function 'ql_init_device':
> drivers/net/qlge/qlge_main.c:4502: error: label 'err_out' used but not defined
> 
> Caused by commit 8aae2600030f54494f9061d2cde141802d774be9 ("qlge: Add
> basic firmware dump") interacting with commit
> 4f9a91c81273b66afe0b6a9be460b47581b28246 ("qlge: Only free resources if
> they were allocated") from Linus' tree.
> 
> I applied the following merge fixup.

Thanks for letting me know, I'll do a merge and make sure this
gets cured just how you fixed it.

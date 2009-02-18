Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZBRB2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZBRB2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZBRB1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54463
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756056AbZBRB1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:17 -0500
Date: Tue, 17 Feb 2009 17:27:01 -0800 (PST)
Message-Id: <20090217.172701.10220214.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/43] drivers/net/bonding: fix sparse warnings:
 context imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214211525.23489.61644.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211525.23489.61644.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:15:33 +0100

> Impact: Attribute functions with __acquires(...) and/or __releases(...).
> 
> Fix this sparse warnings:
>   drivers/net/bonding/bond_alb.c:1675:9: warning: context imbalance in 'bond_alb_handle_active_change' - unexpected unlock
>   drivers/net/bonding/bond_alb.c:1742:9: warning: context imbalance in 'bond_alb_set_mac_address' - unexpected unlock
>   drivers/net/bonding/bond_main.c:1025:17: warning: context imbalance in 'bond_do_fail_over_mac' - unexpected unlock
>   drivers/net/bonding/bond_main.c:3195:13: warning: context imbalance in 'bond_info_seq_start' - wrong count at exit
>   drivers/net/bonding/bond_main.c:3234:13: warning: context imbalance in 'bond_info_seq_stop' - unexpected unlock
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.

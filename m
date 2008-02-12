Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYBLFOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYBLFOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYBLFOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:14:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39591
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYBLFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:14:36 -0500
Date: Mon, 11 Feb 2008 21:15:08 -0800 (PST)
Message-Id: <20080211.211508.186572349.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: rcu_assign_pointer warning fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212012741.GD29254@linux.vnet.ibm.com>
References: <20080211165954.2f1b3a9b@extreme>
	<20080212012741.GD29254@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2008 17:27:41 -0800

> On Mon, Feb 11, 2008 at 04:59:54PM -0800, Stephen Hemminger wrote:
> > Eliminate warnings when rcu_assign_pointer is used with unsigned long.
> > It is reasonable to use RCU with non-pointer values so allow it for general
> > use.  Add a comment to explain the if test.
> 
> Good catch!!!  (An apologies for the hassle!!!)
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks for reviewing Paul, I'll apply this.

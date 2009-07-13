Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGMD0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGMD0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZGMD0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:26:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47780
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbZGMD0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:26:06 -0400
Date: Sun, 12 Jul 2009 20:26:10 -0700 (PDT)
Message-Id: <20090712.202610.254288767.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: julia@diku.dk, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/bonding: Adjust constant name
From: David Miller <davem@davemloft.net>
In-Reply-To: <9220.1247342635@death.nxdomain.ibm.com>
References: <Pine.LNX.4.64.0907111006090.29592@ask.diku.dk>
	<9220.1247342635@death.nxdomain.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Sat, 11 Jul 2009 13:03:55 -0700

> 
> From: Julia Lawall <julia@diku.dk>
> 
> AD_SHORT_TIMEOUT and AD_STATE_LACP_ACTIVITY have the same value, but
> AD_STATE_LACP_ACTIVITY better reflects the intended semantics.
> 
> [ J adds: AD_STATE_LACP_ACTIVITY is a value defined by the standard, and
> should be set here in accordance with 802.3ad 43.4.12; AD_SHORT_TIMEOUT
> is a constant specific to the Linux 802.3ad implementation that happens
> to have the same value ]
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> struct port_params p;
> @@
> * p.port_state |= AD_SHORT_TIMEOUT
> // </smpl>
> 
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

Applied.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZJ1JgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZJ1JgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZJ1JgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:36:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34903
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbZJ1JgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:36:12 -0400
Date: Wed, 28 Oct 2009 02:36:36 -0700 (PDT)
Message-Id: <20091028.023636.92232706.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, dhananjay@netxen.com
Subject: Re: [PATCH -next] netxen: fix builds for SYSFS=n or MODULES=n
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091026150945.3f35a811.randy.dunlap@oracle.com>
References: <20091026172104.205f15af.sfr@canb.auug.org.au>
	<20091026150945.3f35a811.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 26 Oct 2009 15:09:45 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_MODULES=n:
> drivers/net/netxen/netxen_nic_main.c:2751: error: dereferencing pointer to incomplete type
> drivers/net/netxen/netxen_nic_main.c:2764: error: dereferencing pointer to incomplete type
> 
> Also needs addition of <linux/sysfs.h> for sysfs function prototypes or
> stubs when CONFIG_SYSFS=n.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZB0FDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZB0FDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZB0FDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:03:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbZB0FC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:02:59 -0500
Date: Thu, 26 Feb 2009 21:02:40 -0800 (PST)
Message-Id: <20090226.210240.56120085.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, akpm@linux-foundation.org
Subject: Re: [PATCH] net: fix hp-plus build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <49A76A6B.7020709@oracle.com>
References: <20090224212949.0dacb59f.sfr@canb.auug.org.au>
	<49A4248F.6090202@oracle.com>
	<49A76A6B.7020709@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 26 Feb 2009 20:22:03 -0800

> hp-plus needs to call __alloc_eip_netdev() instead of
> __alloc_ei_netdev() since it is linked with 8390p.o.
> 
> Fixes this build error:
> ERROR: "__alloc_ei_netdev" [drivers/net/hp-plus.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied to net-2.6, thanks Randy.

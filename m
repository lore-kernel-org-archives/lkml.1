Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbXCUD0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbXCUD0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbXCUD0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:26:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60015
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932166AbXCUD0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:26:23 -0400
Date: Tue, 20 Mar 2007 20:26:21 -0700 (PDT)
Message-Id: <20070320.202621.74740974.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: BLK_DEV_MD with CONFIG_NET
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070320200538.5270d636.randy.dunlap@oracle.com>
References: <20070320200538.5270d636.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 20 Mar 2007 20:05:38 -0700

> Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
> Unless csum_partial() is built and kept by some arch Makefile,
> the result is:
> ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> 
> Any suggested solutions?

Anything which is every exported to modules, which ought to
be the situation in this case, should be obj-y not lib-y
right?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXDZEpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXDZEpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXDZEpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:45:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48304
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbXDZEps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:45:48 -0400
Date: Wed, 25 Apr 2007 21:45:55 -0700 (PDT)
Message-Id: <20070425.214555.13770473.davem@davemloft.net>
To: k-keiichi@bx.jp.nec.com
Cc: shemminger@linux-foundation.org, akpm@linux-foundation.org,
       mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 2/6] support multiple logging
From: David Miller <davem@davemloft.net>
In-Reply-To: <4630243C.4010402@bx.jp.nec.com>
References: <20070424012902.1089bc02.akpm@linux-foundation.org>
	<20070424082117.354341d3@oldman>
	<4630243C.4010402@bx.jp.nec.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi KII <k-keiichi@bx.jp.nec.com>
Date: Thu, 26 Apr 2007 13:02:04 +0900

> Stephen Hemminger said "The configuration of netconsole's looks like the 
> configuration of routes".
> I think so too.
> So I think ioctl commands for adding/removing port and the following userland 
> application like route(8) command by using the ioctl.

Like the route command itself, the route changing ioctl()s are
old deprecated BSD compatible functionality.

All current routing configuration is done using netlink and the 'ip'
utility.


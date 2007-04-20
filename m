Return-Path: <linux-kernel-owner+w=401wt.eu-S1422974AbXDTG7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422974AbXDTG7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXDTG7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:59:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54929
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbXDTG7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:59:07 -0400
Date: Thu, 19 Apr 2007 23:59:08 -0700 (PDT)
Message-Id: <20070419.235908.122942095.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: akpm@linux-foundation.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take4 6/6] add ioctls for adding/removing
 target
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070419223909.00e8285d@localhost.localdomain>
References: <46260BBF.2070202@bx.jp.nec.com>
	<20070419211630.70c20706.akpm@linux-foundation.org>
	<20070419223909.00e8285d@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 19 Apr 2007 22:39:09 -0700

> Should't this just be a network ioctl against an UDP (AF_INET,
> SOCK_DGRAM) socket?  Also consider netconsole over IPV6 for future
> enhancement.

If it's on a socket use a socket option :-)

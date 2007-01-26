Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbXAZV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbXAZV7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXAZV7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:59:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44771 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbXAZV7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:59:51 -0500
Message-Id: <200701262158.l0QLwP22009461@death.nxdomain.ibm.com>
To: Andy Gospodarek <andy@greyhouse.net>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, akpm@osdl.org,
       michael.monnerie@it-management.at
Subject: Re: [PATCH] bonding: ARP monitoring broken on x86_64 
In-reply-to: <20070126144630.GA30601@gospo.rdu.redhat.com> 
References: <20070126144630.GA30601@gospo.rdu.redhat.com>
Comments: In-reply-to Andy Gospodarek <andy@greyhouse.net>
   message dated "Fri, 26 Jan 2007 09:46:32 -0500."
X-Mailer: MH-E 7.83; nmh 1.1-RC4; GNU Emacs 21.4.1
Date: Fri, 26 Jan 2007 13:58:25 -0800
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Gospodarek <andy@greyhouse.net> wrote:

>While working with the latest bonding code I noticed a nasty problem
>that will prevent arp monitoring from always functioning correctly on
>x86_64 systems. Comparing ints to longs and expecting reliable results
>on x86_64 is a bad idea. With this patch, arp monitoring works correctly
>again.  
>
>This also needs to make its way into the 2.6.19 stable series.
>
>Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

Acked-by: Jay Vosburgh <fubar@us.ibm.com>

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

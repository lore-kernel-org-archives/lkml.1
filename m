Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbXGDOAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbXGDOAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760420AbXGDOAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:00:24 -0400
Received: from waste.org ([66.93.16.53]:48710 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759122AbXGDOAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:00:22 -0400
Date: Wed, 4 Jul 2007 08:59:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 4/9] netconsole: Introduce netconsole_netdev_notifier
Message-ID: <20070704135925.GC11115@waste.org>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110759.28520.37301.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704110759.28520.37301.sendpatchset@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 04:37:59PM +0530, Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [4/9] netconsole: Introduce netconsole_netdev_notifier
> 
> To update fields of underlying netpoll structure at runtime on
> corresponding NETDEV_CHANGEADDR or NETDEV_CHANGENAME notifications.

It's not obvious that we want to do that.

I can have a host with DHCP that uses netconsole to log to a private
network address. This breaks that.

-- 
Mathematics is the supreme nostalgia of our time.

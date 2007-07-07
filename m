Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXGGU1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXGGU1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXGGU1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:27:22 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:37719 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbXGGU1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:27:21 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Sun, 8 Jul 2007 02:19:11 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: KII Keiichi <k-keiichi@bx.jp.nec.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 4/9] netconsole: Introduce netconsole_netdev_notifier
In-Reply-To: <Pine.LNX.4.64.0707080116220.3789@cselinux1.cse.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0707080213560.4839@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110759.28520.37301.sendpatchset@cselinux1.cse.iitk.ac.in>
 <468FDC87.6050702@bx.jp.nec.com> <Pine.LNX.4.64.0707080116220.3789@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Satyam Sharma wrote:
> On Sun, 8 Jul 2007, KII Keiichi wrote:
> [...]
> > But, in the case, we must think of the case of changing IP address 
> > because we can change IP address without disabling the network device and 
> > can't hook the event of changing IP address.
> 
> Well, updating the local _IP_ address (for a particular interface) as
> and when it changes would also be good ... it is another piece of info
> exposed (read-write) to userspace through configfs, so makes sense to
> keep it uptodate.
> [...] (as long as it doesn't break
> anything, as Matt warned earlier). I'm not aware of any existing
> netdevice notifier that'll do this, so I'll look around (or trace
> an ifconfig(8) / ip(8) to see what actually happens).

I think inetaddr_chain / register_inetaddr_notifier() are what I'm
looking for. I'll see if this does the job for us without breaking
anything else.

Satyam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbXGENBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbXGENBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXGENB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:01:26 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:56069 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbXGENBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:01:24 -0400
Message-ID: <468CEAEC.7040102@bx.jp.nec.com>
Date: Thu, 05 Jul 2007 21:58:20 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 8/9] netconsole: Update documentation for dynamic
 reconfigurability
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110819.28520.50445.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110819.28520.50445.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

> + cat enabled				# check if enabled is 1
> + echo 0 > enabled			# disable the target (if required)
> + echo eth2 > dev_name			# set local interface

I think that the above line should change from "echo eth2 > dev_name" to 
"echo -n eth2 > dev_name" or the newline should be removed at store_dev_name().
The default behavior of echo(1) outputs the newline. 
So, if we write appropriate network device name to dev_name, 
the netpoll can't find net_device in netpoll_setup(). 

I don't have enough time now. So I will check your patches more specific 
at the weekend.
Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com

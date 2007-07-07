Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXGGSiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXGGSiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXGGShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:37:03 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40282 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbXGGSg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:36:56 -0400
Message-ID: <468FDC97.3050409@bx.jp.nec.com>
Date: Sun, 08 Jul 2007 03:33:59 +0900
From: KII Keiichi <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 9/9] netconsole: Support dynamic reconfiguration using
 configfs
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in> <20070704110824.28520.11661.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110824.28520.11661.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

> After more discussion, Joel suggested the idea to separately manage the
> lifetimes of the two kinds of netconsole_target objects, those created while
> parsing boot/module options and those created via configfs mkdir(2) from
> userspace, in my driver itself. That adds a little bit of complexity and
> redundancy (multiple item creation and destruction points) in this driver.
> Note that the latter type (configfs-created netconsole_targets) can be
> modified / updated / destroyed at runtime from userspace but the former
> (param string created) cannot, as they are not exposed through our configfs
> namespace. However, this is not really a problem and is similar to current
> behaviour in any case.

Maybe you should add the above description into 
Documentation/networking/netconsole.txt.
The users of netconsole applied these patches may think that they can change 
parameters of netconsole_target(param string created at the time of parsing 
boot/options).

And I'm going to search the another solution of this problem and read the 
code of configfs.

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com



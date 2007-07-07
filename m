Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXGGTQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXGGTQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXGGTQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:16:32 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:41439 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXGGTQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:16:31 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Sun, 8 Jul 2007 01:08:12 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: KII Keiichi <k-keiichi@bx.jp.nec.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 9/9] netconsole: Support dynamic reconfiguration
 using configfs
In-Reply-To: <468FDC97.3050409@bx.jp.nec.com>
Message-ID: <Pine.LNX.4.64.0707080105520.3789@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110824.28520.11661.sendpatchset@cselinux1.cse.iitk.ac.in>
 <468FDC97.3050409@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On Sun, 8 Jul 2007, KII Keiichi wrote:
> Hi Satyam,
> 
> > After more discussion, Joel suggested the idea to separately manage the
> > lifetimes of the two kinds of netconsole_target objects, those created while
> > parsing boot/module options and those created via configfs mkdir(2) from
> > userspace, in my driver itself. That adds a little bit of complexity and
> > redundancy (multiple item creation and destruction points) in this driver.
> > Note that the latter type (configfs-created netconsole_targets) can be
> > modified / updated / destroyed at runtime from userspace but the former
> > (param string created) cannot, as they are not exposed through our configfs
> > namespace. However, this is not really a problem and is similar to current
> > behaviour in any case.
> 
> Maybe you should add the above description into 
> Documentation/networking/netconsole.txt.
> The users of netconsole applied these patches may think that they can change 
> parameters of netconsole_target(param string created at the time of parsing 
> boot/options).

Yes, you're absolutely right. This definitely needs to be mentioned in the
documenation -- I'll take care of this in the next iteration.

Satyam

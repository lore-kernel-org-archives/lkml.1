Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYHWI2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYHWI2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 04:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYHWI2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 04:28:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53878
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbYHWI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 04:28:31 -0400
Date: Sat, 23 Aug 2008 01:28:30 -0700 (PDT)
Message-Id: <20080823.012830.262443664.davem@davemloft.net>
To: Shyam_Iyer@Dell.com
Cc: akpm@linux-foundation.org, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, michaelc@cs.wisc.edu,
       swise@opengridcomputing.com, rdreier@cisco.com, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, divy@chelsio.com, dm@chelsio.com,
       leedom@chelsio.com
Subject: Re: [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA018D73BB@blrx3m10.blr.amer.dell.com>
References: <200808221840.m7MIeuvB004442@localhost.localdomain>
	<20080822124844.b05ee3e8.akpm@linux-foundation.org>
	<46A00B48CC54E4468EF6911F877AC4CA018D73BB@blrx3m10.blr.amer.dell.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <Shyam_Iyer@Dell.com>
Date: Sat, 23 Aug 2008 13:52:26 +0530

> >I'd suggest that the version number just be removed.  It becomes
> meaningless (and often misleading) once a driver is in the mainline
> kernel.  People will >update the driver without changing the version
> number.  Code external to the driver but which affects it can change.

I totally disagree.  I find it very useful when I get a debugging
dump from the user and they have no idea where their kernel
came from nor can figure out how to determine the kernel version.

Sure it might sometimes not get updated for trivial patches that
bypass the maintainer, but the maintainer is always going to bump it
after non-trivial changes.

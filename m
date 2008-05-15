Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYEOGU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYEOGU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYEOGUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:20:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbYEOGUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:20:20 -0400
Date: Wed, 14 May 2008 23:20:14 -0700 (PDT)
Message-Id: <20080514.232014.34303310.davem@davemloft.net>
To: kamalesh@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, shemminger@vyatta.com,
       linville@tuxdriver.com, sri@us.ibm.com, adobriyan@gmail.com,
       apw@shadowen.org, balbir@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] list_for_each_rcu must die: networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <482BC96F.1030008@linux.vnet.ibm.com>
References: <20080424033849.GA4401@linux.vnet.ibm.com>
	<20080515001607.GB20811@linux.vnet.ibm.com>
	<482BC96F.1030008@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date: Thu, 15 May 2008 10:56:07 +0530

> Paul E. McKenney wrote:
> > All uses of list_for_each_rcu() can be profitably replaced by the
> > easier-to-use list_for_each_entry_rcu().  This patch makes this change
> > for networking, in preparation for removing the list_for_each_rcu()
> > API entirely.
> > 
> > Updated to remove the two now-unused variables as noted by Dave Miller,
> > and also to fix my bonehead error detected by Kamalesh Babulal and
> > Alexey Dobriyan.  It now passes LTP on POWER.  And also has valid SOB.
> > Some days it just doesn't pay to get out of bed...
> 
> Hi Paul,
> 
> Thanks, the patch fixes the oops.
> 
> Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Acked-by: David S. Miller <davem@davemloft.net> (lkml.org/lkml/2008/4/23/448)
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I'm fine with these changes, and I acked them already.
They belong as a set with the other list_for_each_rcu killing
patches, so I'm fine with them going all together in Andrew's
tree.

Thanks!

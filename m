Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0CKSFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:05:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50718
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933603Ab0CKSFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:05:00 -0500
Date: Thu, 11 Mar 2010 10:05:19 -0800 (PST)
Message-Id: <20100311.100519.124285161.davem@davemloft.net>
To: mchan@broadcom.com
Cc: brian.haley@hp.com, bonbons@linux-vserver.org, benli@broadcom.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BNX2: Kernel crashes with 2.6.31 and 2.6.31.9
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268329796.9775.125.camel@nseg_linux_HP1.broadcom.com>
References: <1268263973.9775.95.camel@nseg_linux_HP1.broadcom.com>
	<4B9850DC.9060703@hp.com>
	<1268329796.9775.125.camel@nseg_linux_HP1.broadcom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Thu, 11 Mar 2010 09:49:56 -0800

> 
> On Wed, 2010-03-10 at 18:09 -0800, Brian Haley wrote:
>> >> I'm able to cause a netdev_watchdog timeout by changing the coalesce
>> >> settings on my bnx2, I built a little test program for it:
>> > 
>> > Do you run this program in a loop?  How quickly do you see the NETDEV
>> > WATCHDOG?
>> 
>> It's run once, and we see it almost immediately after ETHTOOL_SCOALESCE.
> 
> What's the difference between running the test program and doing ethtool
> -C?  Do you see the issue in either case?  I don't see the issue here
> with ethtool -C.

Probably because the independent program runs faster and thus
can trigger races more easily.

In any case, you should be trying to reproduce his problem with
his test program since he went through the effort of providing
one.

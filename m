Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab0CKSum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:50:42 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1529 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab0CKSui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:50:38 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: BNX2: Kernel crashes with 2.6.31 and 2.6.31.9
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: "brian.haley@hp.com" <brian.haley@hp.com>,
       "bonbons@linux-vserver.org" <bonbons@linux-vserver.org>,
       "Benjamin Li" <benli@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100311.100519.124285161.davem@davemloft.net>
References: <1268263973.9775.95.camel@nseg_linux_HP1.broadcom.com>
 <4B9850DC.9060703@hp.com>
 <1268329796.9775.125.camel@nseg_linux_HP1.broadcom.com>
 <20100311.100519.124285161.davem@davemloft.net>
Date: Thu, 11 Mar 2010 10:38:58 -0800
Message-ID: <1268332738.9775.133.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6787E4FC31G56710814-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2010-03-11 at 10:05 -0800, David Miller wrote:
> From: "Michael Chan" <mchan@broadcom.com>
> Date: Thu, 11 Mar 2010 09:49:56 -0800
> 
> > 
> > On Wed, 2010-03-10 at 18:09 -0800, Brian Haley wrote:
> >> >> I'm able to cause a netdev_watchdog timeout by changing the coalesce
> >> >> settings on my bnx2, I built a little test program for it:
> >> > 
> >> > Do you run this program in a loop?  How quickly do you see the NETDEV
> >> > WATCHDOG?
> >> 
> >> It's run once, and we see it almost immediately after ETHTOOL_SCOALESCE.
> > 
> > What's the difference between running the test program and doing ethtool
> > -C?  Do you see the issue in either case?  I don't see the issue here
> > with ethtool -C.
> 
> Probably because the independent program runs faster and thus
> can trigger races more easily.
> 

That's what I thought, I thought he was running it in a loop and
triggering some race condition.  But he said he only ran it once.  His
program gets the coalesce settings, sleeps for 5 seconds, and then sets
the coalesce settings.

> In any case, you should be trying to reproduce his problem with
> his test program since he went through the effort of providing
> one.
> 

I just tried it and cannot reproduce the problem.

Brian, please provide more information.  Thanks.



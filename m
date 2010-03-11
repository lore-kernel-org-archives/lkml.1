Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab0CKSBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:01:45 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4227 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449Ab0CKSBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:01:44 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: BNX2: Kernel crashes with 2.6.31 and 2.6.31.9
From: "Michael Chan" <mchan@broadcom.com>
To: "Brian Haley" <brian.haley@hp.com>
cc: "Bruno =?ISO-8859-1?Q?Pr=E9mont?=" <bonbons@linux-vserver.org>,
       "Benjamin Li" <benli@broadcom.com>, NetDEV <netdev@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B9850DC.9060703@hp.com>
References: <20091229084929.54912c0c@pluto.restena.lu>
 <1262077540.12520.4.camel@localhost>
 <20091229145403.39f82773@pluto.restena.lu>
 <1262149691.2788.63.camel@localhost>
 <20100219091034.5fbb0165@pluto.restena.lu>
 <1266609426.2610.36.camel@dhcp-10-12-137-130.broadcom.com>
 <20100223131508.4c6cb866@neptune.home>
 <1267493170.2762.45.camel@dhcp-10-12-137-104.broadcom.com>
 <20100302081051.3d1b1c53@pluto.restena.lu>
 <20100302092020.52cfcd0e@pluto.restena.lu>
 <1267567926.19491.175.camel@nseg_linux_HP1.broadcom.com>
 <4B90189B.2040801@hp.com> <4B98268D.2020206@hp.com>
 <1268263973.9775.95.camel@nseg_linux_HP1.broadcom.com>
 <4B9850DC.9060703@hp.com>
Date: Thu, 11 Mar 2010 09:49:56 -0800
Message-ID: <1268329796.9775.125.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6787EF8831G56664917-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-03-10 at 18:09 -0800, Brian Haley wrote:
> >> I'm able to cause a netdev_watchdog timeout by changing the coalesce
> >> settings on my bnx2, I built a little test program for it:
> > 
> > Do you run this program in a loop?  How quickly do you see the NETDEV
> > WATCHDOG?
> 
> It's run once, and we see it almost immediately after ETHTOOL_SCOALESCE.

What's the difference between running the test program and doing ethtool
-C?  Do you see the issue in either case?  I don't see the issue here
with ethtool -C.

Thanks.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYIOXCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYIOXCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 19:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYIOXC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 19:02:29 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2545 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYIOXC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 19:02:28 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: 2.6.27-rc5-mm1
From: "Michael Chan" <mchan@broadcom.com>
To: "Rik van Riel" <riel@redhat.com>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080915180130.10995b90@cuia.bos.redhat.com>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
 <20080915180130.10995b90@cuia.bos.redhat.com>
Date: Mon, 15 Sep 2008 16:00:58 -0700
Message-ID: <1221519658.11021.13.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 64D036F24YK35428196-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-09-15 at 15:01 -0700, Rik van Riel wrote:
> On Thu, 4 Sep 2008 22:40:04 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.27-rc5/2.6.27-rc5-mm1/
> 
> The bnx2 driver has stopped working on 2.6.27-rc5-mm1.
> 
> Plain 2.6.27-rc5 works.  Reversing the bnx2 changes in -mm1 does not
> fix the issue, so something less obvious is going on.
> 
> # ifup eth0
> Determining IP information for eth0...SIOCSIFFLAGS: Invalid argument
> SIOCSIFFLAGS: Invalid argument
> SIOCSIFFLAGS: Invalid argument
> # ifconfig eth0 up
> SIOCSIFFLAGS: Invalid argument
> 
> Bringing up the interface fails with -EINVAL.  Specifically, the
> SIOCSIFFLAGS ioctl is returning -EINVAL:
> 
> ioctl(4, SIOCSIFFLAGS, 0x7fffc841cc40)  = -1 EINVAL (Invalid argument)
> 
> I am running an x86-64 kernel on a Dell pe1950 with these network chips
> on the mainboard:
> 
> 05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> 

Does dmesg show anything when you run ifup?



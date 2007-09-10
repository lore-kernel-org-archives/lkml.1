Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXIJEDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXIJEDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 00:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXIJEDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 00:03:01 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:35280 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbXIJEDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 00:03:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=bleeDCEDaUfzOn4yOZtzZ70/tWydjL68QjFJwP3Kz1xo20pbWi9EWyrqJgtgKTu9;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Mon, 10 Sep 2007 00:02:50 -0400
From: Bill Fink <billfink@mindspring.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       apiszcz@solarrain.com
Subject: Re: In search of 10gbps cards/shootout in Linux?
Message-Id: <20070910000250.1a529e33.billfink@mindspring.com>
In-Reply-To: <Pine.LNX.4.64.0709081241100.22467@p34.internal.lan>
References: <Pine.LNX.4.64.0709081241100.22467@p34.internal.lan>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4db51764287f83c0be3799f9f8f75786f9350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.55.21.22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2007, Justin Piszcz wrote:

> There are various agencies/educational institutions doing testing but was 
> curious if anyone has 'found' a 10 gigabit card shootout measuring the 
> performance between 10 gigabit cards on the 2.6 kernel?  Most of the 
> benchmarks are from the vendors themselves Intel/etc-- was wondering if 
> there were any vendor-independent benchmarks out there?
> 
> Until switches come down in price, 10gbps will be most relegated to 
> business/research use and therefore such benchmarks probably will be hard 
> to come by but I thought I'd ask..

I haven't done any comparisons with other vendor offerings, but I can
highly recommend the Myricom PCI-Express (8x) 10-GigE NICs.  They only
cost about $900 and can do full unidirectional 10-GigE line rate.  And
as a 10-GigE router, they can do full bidirectional 10-GigE line rate
IP forwarding.  Note the choice of system/motherboard/CPU is as
important as the choice of NIC in achieving maximum performance.

Sample nuttcp test:

chance7 -> chance9 10-second TCP test:

[root@chance7 ~]# nuttcp -w10m 192.168.88.16
11817.8125 MB /  10.00 sec = 9909.8073 Mbps 100 %TX 71 %RX

The system specs are:

Tyan Thunder K8WE S2895ANRF motherboard with Nvidia nForce
Professional 2200+2050 chipset, 2 AMD Opteron 254 2.8 GHz CPUs,
4 GB PC3200 ECC REG-DDR 400 memory, and 2 PCI-Express x16 slots
(2 buses).  The systems are running a 2.6.20.7 kernel.

Perhaps others can share their experiences with 10-GigE NICs.

						-Bill

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYKYSja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYKYSja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYKYSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:39:21 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:39013 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYKYSjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:39:21 -0500
Message-ID: <492C464D.4080704@oracle.com>
Date: Tue, 25 Nov 2008 10:39:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [BUILD_FAILURE] linux-next: 20081125 - 8390 network driver build
 fails
References: <20081125213738.881b425e.sfr@canb.auug.org.au> <20081125182542.GA4914@linux.vnet.ibm.com>
In-Reply-To: <20081125182542.GA4914@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.492C464A.005E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Stephen,
> 
> 	allyesconfig build of next-20081125 kernel over x86_32 box fails with
> error message.
> 
> drivers/net/8390p.o: In function `ei_get_stats':
> /usr/local/autobench/autotest/tmp/build/linux/drivers/net/lib8390.c:889: multiple definition of `ei_get_stats'
> drivers/net/8390.o:/usr/local/autobench/var/tmp/build/linux/drivers/net/lib8390.c:889: first defined here
> ld: Warning: size of symbol `ei_get_stats' changed from 106 in drivers/net/8390.o to 148 in drivers/net/8390p.o
> drivers/net/8390p.o: In function `ei_start_xmit':
> /usr/local/autobench/autotest/tmp/build/linux/drivers/net/lib8390.c:310: multiple definition of `ei_start_xmit'
> drivers/net/8390.o:/usr/local/autobench/var/tmp/build/linux/drivers/net/lib8390.c:310: first defined here
> ld: Warning: size of symbol `ei_start_xmit' changed from 598 in drivers/net/8390.o to 610 in drivers/net/8390p.o
> drivers/net/8390p.o: In function `ei_tx_timeout':
> /usr/local/autobench/autotest/tmp/build/linux/drivers/net/lib8390.c:263: multiple definition of `ei_tx_timeout'
> drivers/net/8390.o:/usr/local/autobench/var/tmp/build/linux/drivers/net/lib8390.c:263: first defined here
> drivers/net/8390p.o: In function `ei_set_multicast_list':
> /usr/local/autobench/autotest/tmp/build/linux/drivers/net/lib8390.c:999: multiple definition of `ei_set_multicast_list'
> drivers/net/8390.o:/usr/local/autobench/var/tmp/build/linux/drivers/net/lib8390.c:999: first defined here
> make[2]: *** [drivers/net/built-in.o] Error 1

Hi,
I just reported this on netdev and said that DaveM might want to drop a patch
that I had submitted.  Anyway, I'm looking into it.

Thanks.

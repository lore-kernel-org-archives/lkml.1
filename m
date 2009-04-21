Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbZDUUCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbZDUUCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZDUUBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:01:51 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50330 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDUUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:01:50 -0400
Message-ID: <49EE25D8.6040906@freescale.com>
Date: Tue, 21 Apr 2009 15:00:24 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: Jim Cromie <jim.cromie@gmail.com>, carolyn.j.smith@exgate.tek.com,
       Adrian Bunk <bunk@kernel.org>, sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       linux-next <linux-next@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [BUILD FAILURE 10/12] Next April 21 : PPC64 randconfig	[drivers/mtd/maps/sbc8240.o]
References: <1240340059.9110.143.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1240340059.9110.143.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> This is a very old one. Doesn´t seem to go away. Reported this earlier
> on 14th April:
> http://lkml.org/lkml/2009/4/14/483,
> 
> CC [M]  drivers/mtd/maps/sbc8240.o
> drivers/mtd/maps/sbc8240.c:31:1: warning: "DEBUG" redefined
> In file included from drivers/mtd/maps/sbc8240.c:23:
> include/linux/mtd/mtd.h:339:1: warning: this is the location of the
> previous definition
> drivers/mtd/maps/sbc8240.c: In function ‘init_sbc8240_mtd’:
> drivers/mtd/maps/sbc8240.c:172: error: ‘sbc8240_mtd’ undeclared (first
> use in this function)
> drivers/mtd/maps/sbc8240.c:172: error: (Each undeclared identifier is
> reported only once
> drivers/mtd/maps/sbc8240.c:172: error: for each function it appears in.)
> drivers/mtd/maps/sbc8240.c: In function ‘cleanup_sbc8240_mtd’:
> drivers/mtd/maps/sbc8240.c:233: error: ‘sbc8240_mtd’ undeclared (first
> use in this function)

This looks like an arch/ppc orphan.  It's not enabled by any defconfig, 
and it doesn't look like it does anything that physmap_of can't do.

I'd just remove it.

-Scott

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYFYHVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYFYHVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYFYHUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:20:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40171 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYFYHUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:20:52 -0400
Message-ID: <4861F1CD.4080706@garzik.org>
Date: Wed, 25 Jun 2008 03:20:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-sh <linux-sh@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [git patches] net driver updates for .27
References: <20080625031508.GA29896@havoc.gtf.org> <4861C5EA.1050900@renesas.com>
In-Reply-To: <4861C5EA.1050900@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobuhiro Iwamatsu wrote:
> Hello, Jeff.
> 
> Jeff Garzik wrote:
>> Please pull from 'davem-next' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git 
>> davem-next
>>
>> to receive the following updates:
>>
>>  Documentation/networking/dm9000.txt             |  167 ++++
>>  arch/blackfin/mach-bf527/boards/ezkit.c         |    7 +-
>>  arch/blackfin/mach-bf533/boards/H8606.c         |    7 +-
>>  arch/blackfin/mach-bf537/boards/generic_board.c |    7 +-
>>  drivers/net/Kconfig                             |   28 +-
>>  drivers/net/cxgb3/cxgb3_offload.c               |   21 +-
>>  drivers/net/cxgb3/t3cdev.h                      |    3 +-
>>  drivers/net/dm9000.c                            | 1159 
>> ++++++++++++-----------
>>  drivers/net/dm9000.h                            |   11 +
>>  drivers/net/ixgbe/ixgbe.h                       |    9 +
>>  drivers/net/ixgbe/ixgbe_ethtool.c               |   11 +
>>  drivers/net/ixgbe/ixgbe_main.c                  |  111 ++-
>>  drivers/net/tulip/21142.c                       |    6 +-
>>  drivers/net/tulip/eeprom.c                      |    6 +-
>>  drivers/net/tulip/interrupt.c                   |    5 +-
>>  drivers/net/tulip/media.c                       |    5 +-
>>  drivers/net/tulip/pnic.c                        |    5 +-
>>  drivers/net/tulip/pnic2.c                       |    5 +-
>>  drivers/net/tulip/timer.c                       |    6 +-
>>  drivers/net/tulip/tulip.h                       |    4 +-
>>  drivers/net/tulip/tulip_core.c                  |    8 +-
>>  include/linux/dm9000.h                          |    1 +
>>  22 files changed, 968 insertions(+), 624 deletions(-)
>>  create mode 100644 Documentation/networking/dm9000.txt
>>
>> Ben Dooks (10):
>>       DM9000: Add support for DM9000A and DM9000B chips
>>       DM9000: Cleanups after the resource changes
>>       DM9000: Cleanup source code
>>       DM9000: Cleanup source code - remove forward declerations
>>       DM9000: Use NSR to determine link-status on internal PHY
>>       DM9000: Allow the use of the NSR register to get link status.
>>       DM9000: Add missing msleep() in EEPROM wait code.
>>       DM9000: Re-unite menuconfig entries for DM9000 driver
>>       DM9000: Remove DEFAULT_TRIGGER for request_irq() flags.
>>       DM9000: Add documentation for the driver.
>>
>> Divy Le Ray (1):
>>       cxgb3 - add missing adapter type for RDMA
>>
>> Grant Grundler (1):
>>       drivers/net/tulip: update first comment in tulip files
>>
>> Laurent Pinchart (2):
>>       DM9000: Remove the 2 resources probe scheme.
>>       DM9000: Fixup blackfin after removing 2 resource usage
>>
>> Mallikarjuna R Chilakala (1):
>>       ixgbe: add LRO support
> 
> Could you take in these paches for .27 ?
> [PATCH] net: sh_eth: Fix compile error sh_eth
>   http://marc.info/?l=linux-netdev&m=121378156319203
> [PATCH] net: sh_eth: Add support of SH7763 to sh_eth
>   http://marc.info/?l=linux-netdev&m=121387121430572

Yes, they are already in the queue.  The above is just the first batch.

	Jeff




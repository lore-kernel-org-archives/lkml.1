Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYKSTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYKSTGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKSTGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:06:37 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38086 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYKSTGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:06:36 -0500
Message-ID: <492463A1.3000306@oracle.com>
Date: Wed, 19 Nov 2008 11:06:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Brown <mbrown@fensystems.co.uk>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: linux-next: Tree for November 19 (mtd build error)
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>	 <20081119105321.477e618a.randy.dunlap@oracle.com> <1227121104.27728.618.camel@macbook.infradead.org>
In-Reply-To: <1227121104.27728.618.camel@macbook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.492463A5.00E5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Wed, 2008-11-19 at 10:53 -0800, Randy Dunlap wrote:
>> On Wed, 19 Nov 2008 17:59:17 +1100 Stephen Rothwell wrote:
>>
>> (.text+0x104879): undefined reference to `add_mtd_device'
>> (.text+0x1048e1): undefined reference to `del_mtd_device'
>> mtd.c:(.text+0x104999): undefined reference to `mtd_erase_callback'
>>
>>
>> config attached.
> 
> CONFIG_SFC_MTD=y
> 
> What's that?

drivers/net/sfc/Kconfig:

config SFC_MTD
	bool "Solarflare Solarstorm SFC4000 flash MTD support"
	depends on SFC && MTD
	default y
	help
	  This exposes the on-board flash memory as an MTD device (e.g.
          /dev/mtd1).  This makes it possible to upload new boot code
          to the NIC.


sfc people added to cc.

-- 
~Randy

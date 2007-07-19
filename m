Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXGSUu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXGSUu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760422AbXGSUuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:50:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35728 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbXGSUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:50:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469FCE5E.80803@s5r6.in-berlin.de>
Date: Thu, 19 Jul 2007 22:49:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
References: <469BBDAD.2010908@s5r6.in-berlin.de> <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr> <20070718094119.4a26ae03.randy.dunlap@oracle.com> <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0707192219380.18342@anakin>
In-Reply-To: <Pine.LNX.4.64.0707192219380.18342@anakin>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 18 Jul 2007, Jan Engelhardt wrote:
>> Add some help texts to recently-introduced kconfig items
>>
>> Index: linux-2.6.23/drivers/macintosh/Kconfig
>> ===================================================================
>> --- linux-2.6.23.orig/drivers/macintosh/Kconfig
>> +++ linux-2.6.23/drivers/macintosh/Kconfig
>> @@ -3,6 +3,12 @@ menuconfig MACINTOSH_DRIVERS
>>  	bool "Macintosh device drivers"
>>  	depends on PPC || MAC || X86
>>  	default y if (PPC_PMAC || MAC)
>> +	---help---
>> +	  Say Y here to get to see options for devices used with Macintosh
>> +	  computers, both PPC and Intel based. This option alone does not add
>                                   ^^^^^
>> +	  any kernel code.
>> +
>> +	  If you say N, all options in this submenu will be skipped and disabled.
> 
> `MAC' is the symbol for m68k Macs.

OK, then this should read

	  Say Y here to get to see options for devices used with Macintosh
	  computers. This option alone does not add any kernel code.

	  If you say N, all options in this submenu will be skipped and disabled.

> From a quick look at drivers/macintosh/Kconfig, all of the entries are for m68k
> and PPC Macs only.  The only thing that depends on X86 is the main menu...

There is one entry for all sorts of Macs, MAC_EMUMOUSEBTN.
-- 
Stefan Richter
-=====-=-=== -=== =--==
http://arcgraph.de/sr/

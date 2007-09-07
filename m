Return-Path: <linux-kernel-owner+w=401wt.eu-S965604AbXIGQVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604AbXIGQVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbXIGQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:21:24 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49572 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbXIGQVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:21:23 -0400
Message-ID: <46E17A81.7020304@s5r6.in-berlin.de>
Date: Fri, 07 Sep 2007 18:21:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com> <20070907155903.GR16806@vanheusden.com>
In-Reply-To: <20070907155903.GR16806@vanheusden.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden wrote:
>> I know that it's difficult to get people to read docs & help text,
>> and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
>> help text says:
>>   NOTE: ATA enables basic SCSI support; *however*,
>>   'SCSI disk support', 'SCSI tape support', or
>>   'SCSI CDROM support' may also be needed,
>>   depending on your hardware configuration.
> 
> Yes but that would mean that you have to open the help for each item
> that you add.
> 
>> A popup makes some sense, but I don't know if menuconfig knows how to
>> do popup warnings... and it needs to be done for all *configs,
>> not just menuconfig.
> 
> Maybe add a new type?

How about

comment "Note: 'SCSI disk support' is required for SATA/PATA HDDs!"
	depends on ATA && !BLK_DEV_SD

-- 
Stefan Richter
-=====-=-=== =--= --===
http://arcgraph.de/sr/

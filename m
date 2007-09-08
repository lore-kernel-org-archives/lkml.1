Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXIHQqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXIHQqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbXIHQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:45:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37887 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbXIHQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:45:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E2D17E.9050805@s5r6.in-berlin.de>
Date: Sat, 08 Sep 2007 18:44:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com> <20070907155903.GR16806@vanheusden.com> <46E17A81.7020304@s5r6.in-berlin.de> <20070907230529.GX16806@vanheusden.com> <46E249CB.5070505@s5r6.in-berlin.de> <46E2CE73.3000207@oracle.com>
In-Reply-To: <46E2CE73.3000207@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Stefan Richter wrote:
>> I am not a friend of 'select', but maybe the following actually helps.
...
> The problem with 'select' here is that it will enable BLK_DEV_SD,
> but if SCSI is not enabled, it will not become enabled -- i.e.,
> select does not follow the dependency chain.  So usually the
> kernel will not build unless SCSI is enabled by the user.
...
>> config ATA_SD
>>     tristate "SATA/PATA HDD support (via SCSI disk support)"
>>     depends on ATA
>>     select BLK_DEV_SD
>>     help
>>       'SCSI disk support' is required to access SATA HDDs.  It is
...

I checked the dependencies.  ATA depends on SCSI (actually, selects
SCSI), so all is well.  Otherwise I would have added more dependencies
to ATA_SD.
-- 
Stefan Richter
-=====-=-=== =--= -=---
http://arcgraph.de/sr/

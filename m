Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbXINQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbXINQmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXINQmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:42:08 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:63360 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbXINQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:42:06 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com>
	<20070907083522.3191a4ba.randy.dunlap@oracle.com>
	<46E8F9D4.10307@aitel.hist.no>
Date: Fri, 14 Sep 2007 18:42:02 +0200
In-Reply-To: <46E8F9D4.10307@aitel.hist.no> (Helge Hafting's message of "Thu,
	13 Sep 2007 10:50:28 +0200")
Message-ID: <87myvpqjvp.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting <helge.hafting@aitel.hist.no> writes:

> Randy Dunlap wrote:
>> On Fri, 7 Sep 2007 14:48:00 +0200 Folkert van Heusden wrote:
>>
>>
>>> Hi,
>>>
>>> Maybe it is a nice enhancement for make menuconfig to more explicitly
>>> give a pop-up or so when someone selects for example a sata controller
>>> while no 'scsi-disk' support was selected?
>>>
>>
>> I know that it's difficult to get people to read docs & help text,
>> and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
>> help text says:
>>
>>   NOTE: ATA enables basic SCSI support; *however*,
>>   'SCSI disk support', 'SCSI tape support', or
>>   'SCSI CDROM support' may also be needed,
>>   depending on your hardware configuration.

Could one duplicate the configure options for scsi disk/tape/cdrom at
that place? The text should then probably read SCSI/SATA disk support
in both places.

MfG
        Goswin

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbXIMI4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbXIMI4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXIMI4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:56:39 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:49426 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbXIMI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:56:38 -0400
Message-ID: <46E8F9D4.10307@aitel.hist.no>
Date: Thu, 13 Sep 2007 10:50:28 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com>
In-Reply-To: <20070907083522.3191a4ba.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 7 Sep 2007 14:48:00 +0200 Folkert van Heusden wrote:
>
>   
>> Hi,
>>
>> Maybe it is a nice enhancement for make menuconfig to more explicitly
>> give a pop-up or so when someone selects for example a sata controller
>> while no 'scsi-disk' support was selected?
>>     
>
> I know that it's difficult to get people to read docs & help text,
> and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
> help text says:
>
>   NOTE: ATA enables basic SCSI support; *however*,
>   'SCSI disk support', 'SCSI tape support', or
>   'SCSI CDROM support' may also be needed,
>   depending on your hardware configuration.
>
>
> A popup makes some sense, but I don't know if menuconfig knows how to
> do popup warnings... and it needs to be done for all *configs,
> not just menuconfig.
>   
A popup hardly ever makes sense - popups generally are a
bad user interface. The user will have to dismiss the popup -
every time - whether he needs the warning or not.

But feel free to print a warning somewhere, such as a
status line. The warning itself is useful, but not something
we will have to dismiss in order to go on with the job.

Helge Hafting




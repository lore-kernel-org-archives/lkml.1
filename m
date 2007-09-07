Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbXIGPh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbXIGPh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXIGPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:37:13 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32793 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbXIGPhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:37:11 -0400
Date: Fri, 7 Sep 2007 08:35:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-Id: <20070907083522.3191a4ba.randy.dunlap@oracle.com>
In-Reply-To: <20070907124800.GP16806@vanheusden.com>
References: <20070907124800.GP16806@vanheusden.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2007 14:48:00 +0200 Folkert van Heusden wrote:

> Hi,
> 
> Maybe it is a nice enhancement for make menuconfig to more explicitly
> give a pop-up or so when someone selects for example a sata controller
> while no 'scsi-disk' support was selected?

I know that it's difficult to get people to read docs & help text,
and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
help text says:

  NOTE: ATA enables basic SCSI support; *however*,
  'SCSI disk support', 'SCSI tape support', or
  'SCSI CDROM support' may also be needed,
  depending on your hardware configuration.


A popup makes some sense, but I don't know if menuconfig knows how to
do popup warnings... and it needs to be done for all *configs,
not just menuconfig.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

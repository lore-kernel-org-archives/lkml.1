Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXIHH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXIHH3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXIHH3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:29:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46557 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXIHH3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:29:12 -0400
Date: Sat, 8 Sep 2007 09:29:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Folkert van Heusden <folkert@vanheusden.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
In-Reply-To: <46E249CB.5070505@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0709080927490.25942@fbirervta.pbzchgretzou.qr>
References: <20070907124800.GP16806@vanheusden.com>
 <20070907083522.3191a4ba.randy.dunlap@oracle.com> <20070907155903.GR16806@vanheusden.com>
 <46E17A81.7020304@s5r6.in-berlin.de> <20070907230529.GX16806@vanheusden.com>
 <46E249CB.5070505@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 8 2007 09:05, Stefan Richter wrote:
>config ATA
>	[...]
>
>comment "Controller drivers"
>
>[...low-level drivers go here...]
>
>comment "Storage device drivers"
>
>config ATA_SD
>	tristate "SATA/PATA HDD support (via SCSI disk support)"
>	depends on ATA
>	select BLK_DEV_SD
>	help
>	  'SCSI disk support' is required to access SATA HDDs.  It is
>	  also necessary for parallel ATA (IDE) HDDs if you use the
>	  experimental parallel ATA option.
>
>	  You can say Y or M here to select SCSI disk support, or you
>	  can do so in the 'SCSI device support' section.
>
>[...ditto for CD/DVD-ROMs, tapes, and generic support...]

And what uses ATA_SD, or is the user supposed to manually enable it?



	Jan
-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbXIGXGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbXIGXGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXIGXG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:06:27 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1029 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXIGXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:06:26 -0400
Date: Sat, 8 Sep 2007 01:05:29 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070907230529.GX16806@vanheusden.com>
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com> <20070907155903.GR16806@vanheusden.com> <46E17A81.7020304@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46E17A81.7020304@s5r6.in-berlin.de>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Sep  7 11:31:04 CEST 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> I know that it's difficult to get people to read docs & help text,
> >> and maybe it is needed in more places, but CONFIG_ATA (SATA/PATA)
> >> help text says:
> >>   NOTE: ATA enables basic SCSI support; *however*,
> >>   'SCSI disk support', 'SCSI tape support', or
> >>   'SCSI CDROM support' may also be needed,
> >>   depending on your hardware configuration.
> > 
> > Yes but that would mean that you have to open the help for each item
> > that you add.
> > 
> >> A popup makes some sense, but I don't know if menuconfig knows how to
> >> do popup warnings... and it needs to be done for all *configs,
> >> not just menuconfig.
> > 
> > Maybe add a new type?
> 
> How about
> comment "Note: 'SCSI disk support' is required for SATA/PATA HDDs!"
> 	depends on ATA && !BLK_DEV_SD

Yes! Maybe create some status-line at the bottom of the screen in which
these hints scrollby. Like powertop does.


Folkert van Heusden

-- 
MultiTail är en flexibel redskap för att fälja logfilar, utför av
commandoer, filtrera, ge färg, sammanfoga, o.s.v. följa.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

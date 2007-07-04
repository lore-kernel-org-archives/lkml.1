Return-Path: <linux-kernel-owner+w=401wt.eu-S1761723AbXGDOTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723AbXGDOTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbXGDOTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:19:13 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:46422 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759144AbXGDOTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:19:13 -0400
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Libata PATA status
Date: Wed, 4 Jul 2007 16:18:45 +0200
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20070703185116.59c8f5f5@the-village.bc.nu> <200707041332.00769.marc.dietrich@ap.physik.uni-giessen.de> <20070704131023.66a3cca7@the-village.bc.nu>
In-Reply-To: <20070704131023.66a3cca7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041618.52249.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Am Wednesday 04 July 2007 14:10 schrieb Alan Cox:
> > I'm using pata-cmd64x for a few month now on my G3 powermac. So far no
> > problems except it only runs in UDMA/25 mode instead of UDMA/33 as the
> > ide driver does. And of course - no cdrom or zip because they are
> > connected to
>
> That looks like a dumb bug actually. What chip variant do you have ?

lspci -vnn gives

01:01.0 IDE interface [0101]: Silicon Image, Inc. PCI0646 [1095:0646] (rev 07) 
(prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Silicon Image, Inc. PCI0646 [1095:0646]
        Flags: bus master, medium devsel, latency 64, IRQ 26
        I/O ports at 1090 [size=8]
        I/O ports at 1080 [size=4]
        I/O ports at 1070 [size=8]
        I/O ports at 1060 [size=4]
        I/O ports at 1050 [size=16]
        Capabilities: [60] Power Management version 1


Marc

-- 
	"Our cause has a sacred nature."
		 Lord Arthur Ponsonby, "Falsehood in Wartime: Propaganda Lies of the First 
World War", 1928
